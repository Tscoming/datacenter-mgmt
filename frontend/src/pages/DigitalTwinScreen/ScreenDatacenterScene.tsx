import {
  Billboard,
  Grid,
  Html,
  OrbitControls,
  PerspectiveCamera,
  Text,
} from '@react-three/drei';
import { useFrame, useThree } from '@react-three/fiber';
import { history } from '@umijs/max';
import { useEffect, useMemo, useRef, useState } from 'react';
import * as THREE from 'three';
import type { CabinetTelemetrySourceState } from '@/services/idc/telemetry';

interface ScreenDatacenterSceneProps {
  layout: IDC.DatacenterLayout;
  cabinets: IDC.Cabinet[];
  devices: IDC.Device[];
  cabinetEnvironments: IDC.CabinetEnvironment[];
  cabinetTelemetry: Record<string, CabinetTelemetrySourceState>;
  telemetryWarning?: string;
  onSelectedCabinetChange: (cabinetId: string | null) => void;
  connections: IDC.Connection[];
  connectionTypes: { value: string; label: string; color: string }[];
  showConnections: boolean;
  showCabinetNames: boolean;
  showHeatmap: boolean;
  enabledConnectionTypes: string[];
}

const statusColor: Record<string, string> = {
  normal: '#00f0ff',
  warning: '#ffb000',
  error: '#ff3d71',
  offline: '#64748b',
  critical: '#ff3d71',
};

const statusText: Record<string, string> = {
  normal: '正常',
  warning: '告警',
  error: '故障',
  offline: '离线',
  critical: '严重',
};

const disableRaycast = () => undefined;
const CABINET_LAYOUT_WIDTH = 0.6;
const CABINET_LAYOUT_DEPTH = 1.0;
const AIRFLOW_PARTICLE_COUNT = 72;

interface CabinetScenePosition {
  x: number;
  z: number;
}

interface CabinetHeatmapPoint extends CabinetScenePosition {
  cabinetId: string;
  temperature: number;
}

interface CabinetConnectionLine {
  id: string;
  sourceCabinetId: string;
  targetCabinetId: string;
  connectionType: IDC.ConnectionType;
  color: string;
  index: number;
  total: number;
}

const zoneColor = (type: IDC.LayoutZoneType) => {
  if (type === 'hot_aisle') return '#ff3d71';
  if (type === 'cold_aisle') return '#00d9ff';
  if (type === 'restricted') return '#ffb000';
  return '#16f19a';
};

const zoneLabel = (type: IDC.LayoutZoneType) => {
  if (type === 'hot_aisle') return '热通道';
  if (type === 'cold_aisle') return '冷通道';
  if (type === 'restricted') return '受限区';
  if (type === 'zone') return '区域';
  return '其他区域';
};

const CabinetGlow: React.FC<{ color: string; width: number; height: number; depth: number }> = ({
  color,
  width,
  height,
  depth,
}) => (
  <lineSegments>
    <edgesGeometry args={[new THREE.BoxGeometry(width + 0.035, height + 0.035, depth + 0.035)]} />
    <lineBasicMaterial color={color} transparent opacity={0.85} />
  </lineSegments>
);

const StatusLight: React.FC<{ color: string; alerting: boolean; position: [number, number, number] }> = ({
  color,
  alerting,
  position,
}) => {
  const materialRef = useRef<THREE.MeshStandardMaterial>(null);

  useFrame(({ clock }) => {
    if (!materialRef.current) return;
    const pulse = alerting ? Math.sin(clock.elapsedTime * 5) * 0.7 + 1.2 : 0.9;
    materialRef.current.emissiveIntensity = pulse;
  });

  return (
    <mesh position={position}>
      <sphereGeometry args={[0.035, 18, 18]} />
      <meshStandardMaterial
        ref={materialRef}
        color={color}
        emissive={color}
        emissiveIntensity={1}
        toneMapped={false}
      />
    </mesh>
  );
};

const temperatureColor = (temperature: number) => {
  if (temperature <= 18) return '#2b83ff';
  if (temperature <= 22) return '#00eaff';
  if (temperature <= 26) return '#16f19a';
  if (temperature <= 28) return '#ffe066';
  if (temperature <= 30) return '#ff9f43';
  return '#ff3d71';
};

const CabinetHeatmapLayer: React.FC<{ points: CabinetHeatmapPoint[] }> = ({ points }) => (
  <group>
    {points.map((point) => {
      const color = temperatureColor(point.temperature);
      return (
        <group key={point.cabinetId} position={[point.x, 0.012, point.z]}>
          <mesh rotation={[-Math.PI / 2, 0, 0]} raycast={disableRaycast}>
            <circleGeometry args={[0.82, 48]} />
            <meshBasicMaterial
              color={color}
              transparent
              opacity={0.34}
              blending={THREE.AdditiveBlending}
              depthWrite={false}
              toneMapped={false}
            />
          </mesh>
          <mesh position={[0, 1.36, 0]} raycast={disableRaycast}>
            <cylinderGeometry args={[0.34, 0.68, 2.72, 32, 1, true]} />
            <meshBasicMaterial
              color={color}
              transparent
              opacity={0.16}
              blending={THREE.AdditiveBlending}
              depthWrite={false}
              side={THREE.DoubleSide}
              toneMapped={false}
            />
          </mesh>
          <Html position={[0, 3.05, 0]} center style={{ pointerEvents: 'none' }}>
            <div
              style={{
                padding: '2px 6px',
                color: '#ffffff',
                fontSize: 10,
                fontWeight: 700,
                whiteSpace: 'nowrap',
                border: `1px solid ${color}`,
                borderRadius: 4,
                background: 'rgba(3, 18, 30, 0.88)',
                boxShadow: `0 0 10px ${color}`,
              }}
            >
              {point.temperature.toFixed(1)}℃
            </div>
          </Html>
        </group>
      );
    })}
  </group>
);

const detailSectionStyle = {
  marginTop: 8,
  paddingTop: 7,
  borderTop: '1px solid rgba(92, 224, 238, 0.2)',
};

const detailSectionTitleStyle = {
  marginBottom: 3,
  color: '#5ce0ee',
  fontSize: 11,
  fontWeight: 700,
  letterSpacing: 1,
};

const detailMutedStyle = {
  color: '#7ea7b0',
};

const CabinetConnectionCurve: React.FC<{
  line: CabinetConnectionLine;
  source: CabinetScenePosition;
  target: CabinetScenePosition;
}> = ({ line, source, target }) => {
  const glowMaterialRef = useRef<THREE.MeshBasicMaterial>(null);
  const coreMaterialRef = useRef<THREE.MeshBasicMaterial>(null);
  const cableCurve = useMemo(() => {
    const cabinetTopY = 2.72;
    const start = new THREE.Vector3(source.x, cabinetTopY + 0.08, source.z);
    const end = new THREE.Vector3(target.x, cabinetTopY + 0.08, target.z);
    const direction = end.clone().sub(start);
    const distance = Math.max(direction.length(), 0.1);
    const normal = new THREE.Vector3(-direction.z, 0, direction.x).normalize();
    const offset = (line.index - (line.total - 1) / 2) * 0.16;
    const startPoint = start.clone().add(normal.clone().multiplyScalar(offset * 0.35));
    const endPoint = end.clone().add(normal.clone().multiplyScalar(offset * 0.35));
    const archHeight = Math.min(2.2, Math.max(0.58, distance * 0.18));
    const startControl = startPoint
      .clone()
      .lerp(endPoint, 0.26)
      .add(new THREE.Vector3(0, archHeight, 0))
      .add(normal.clone().multiplyScalar(offset * 0.28));
    const endControl = endPoint
      .clone()
      .lerp(startPoint, 0.26)
      .add(new THREE.Vector3(0, archHeight, 0))
      .add(normal.clone().multiplyScalar(offset * 0.28));

    return new THREE.CubicBezierCurve3(startPoint, startControl, endControl, endPoint);
  }, [line.index, line.total, source.x, source.z, target.x, target.z]);

  useFrame(({ clock }) => {
    if (glowMaterialRef.current) {
      glowMaterialRef.current.opacity = 0.12 + Math.sin(clock.elapsedTime * 2 + line.index) * 0.035;
    }
    if (coreMaterialRef.current) {
      coreMaterialRef.current.opacity = 0.78 + Math.sin(clock.elapsedTime * 3.4 + line.index) * 0.12;
    }
  });

  return (
    <group>
      <mesh raycast={disableRaycast}>
        <tubeGeometry args={[cableCurve, 72, 0.052, 10, false]} />
        <meshBasicMaterial
          ref={glowMaterialRef}
          color={line.color}
          transparent
          opacity={0.14}
          blending={THREE.AdditiveBlending}
          depthWrite={false}
          toneMapped={false}
        />
      </mesh>
      <mesh raycast={disableRaycast}>
        <tubeGeometry args={[cableCurve, 72, 0.012, 8, false]} />
        <meshBasicMaterial
          ref={coreMaterialRef}
          color={line.color}
          transparent
          opacity={0.84}
          blending={THREE.AdditiveBlending}
          depthWrite={false}
          toneMapped={false}
        />
      </mesh>
    </group>
  );
};

const CabinetConnectionLayer: React.FC<{
  lines: CabinetConnectionLine[];
  cabinetPositions: Map<string, CabinetScenePosition>;
}> = ({ lines, cabinetPositions }) => (
  <group>
    {lines.map((line) => {
      const source = cabinetPositions.get(line.sourceCabinetId);
      const target = cabinetPositions.get(line.targetCabinetId);
      if (!source || !target) return null;

      return (
        <CabinetConnectionCurve
          key={line.id}
          line={line}
          source={source}
          target={target}
        />
      );
    })}
  </group>
);

const AisleAirflow: React.FC<{ zone: IDC.DatacenterLayoutZoneItem }> = ({ zone }) => {
  const instancedRef = useRef<THREE.InstancedMesh>(null);
  const ribbonRefs = useRef<THREE.Mesh[]>([]);
  const dummy = useMemo(() => new THREE.Object3D(), []);
  const isHot = zone.type === 'hot_aisle';
  const color = isHot ? '#ff5a3d' : '#00d9ff';
  const direction = isHot ? -1 : 1;
  const flowLength = Math.max(zone.width, 0.1);
  const flowWidth = Math.max(zone.height, 0.1);
  const streamCount = Math.max(3, Math.min(7, Math.round(flowWidth * 4)));

  const particleSeeds = useMemo(
    () =>
      Array.from({ length: AIRFLOW_PARTICLE_COUNT }, (_, index) => ({
        lane: index % streamCount,
        offset: index / AIRFLOW_PARTICLE_COUNT,
        speed: 0.55 + (index % 9) * 0.045,
        phase: index * 0.71,
        scale: 0.026 + (index % 5) * 0.006,
      })),
    [streamCount],
  );

  const streamCurves = useMemo(
    () =>
      Array.from({ length: streamCount }, (_, index) => {
        const laneRatio = streamCount === 1 ? 0.5 : index / (streamCount - 1);
        const z = -flowWidth / 2 + laneRatio * flowWidth;
        const phase = index * 0.85;
        const points = Array.from({ length: 9 }, (_, pointIndex) => {
          const t = pointIndex / 8;
          const x = -flowLength / 2 + t * flowLength;
          return new THREE.Vector3(
            x,
            0.2 + Math.sin(t * Math.PI * 2 + phase) * 0.035,
            z + Math.sin(t * Math.PI * 3 + phase) * Math.min(0.18, flowWidth * 0.13),
          );
        });
        return new THREE.CatmullRomCurve3(points);
      }),
    [flowLength, flowWidth, streamCount],
  );

  useFrame(({ clock }) => {
    const elapsed = clock.elapsedTime;
    const mesh = instancedRef.current;

    if (mesh) {
      particleSeeds.forEach((seed, index) => {
        const laneRatio = streamCount === 1 ? 0.5 : seed.lane / (streamCount - 1);
        const progress = (seed.offset + elapsed * seed.speed * 0.16) % 1;
        const x = direction * (-flowLength / 2 + progress * flowLength);
        const baseZ = -flowWidth / 2 + laneRatio * flowWidth;
        const z =
          baseZ + Math.sin(progress * Math.PI * 4 + seed.phase) * Math.min(0.16, flowWidth * 0.12);
        const y = 0.18 + Math.sin(elapsed * 2.1 + seed.phase) * 0.055;
        const pulse = 0.72 + Math.sin(elapsed * 4 + seed.phase) * 0.22;

        dummy.position.set(x, y, z);
        dummy.scale.setScalar(seed.scale * pulse);
        dummy.updateMatrix();
        mesh.setMatrixAt(index, dummy.matrix);
      });
      mesh.instanceMatrix.needsUpdate = true;
    }

    ribbonRefs.current.forEach((ribbon, index) => {
      const material = ribbon.material as THREE.MeshBasicMaterial;
      material.opacity = 0.12 + Math.sin(elapsed * 1.6 + index * 0.7) * 0.035;
    });
  });

  if (zone.type !== 'cold_aisle' && zone.type !== 'hot_aisle') return null;

  return (
    <group
      position={[zone.x + zone.width / 2, 0.035, zone.y + zone.height / 2]}
      rotation={[0, ((zone.rotation || 0) * Math.PI) / 180, 0]}
    >
      {streamCurves.map((curve, index) => (
        <mesh
          key={`${zone.id}-stream-${index}`}
          ref={(node) => {
            if (node) ribbonRefs.current[index] = node;
          }}
        >
          <tubeGeometry args={[curve, 36, 0.018, 8, false]} />
          <meshBasicMaterial
            color={color}
            transparent
            opacity={0.12}
            blending={THREE.AdditiveBlending}
            depthWrite={false}
            toneMapped={false}
          />
        </mesh>
      ))}

      <instancedMesh ref={instancedRef} args={[undefined, undefined, AIRFLOW_PARTICLE_COUNT]}>
        <sphereGeometry args={[1, 10, 10]} />
        <meshBasicMaterial
          color={color}
          transparent
          opacity={0.74}
          blending={THREE.AdditiveBlending}
          depthWrite={false}
          toneMapped={false}
        />
      </instancedMesh>

      <mesh
        position={[direction * (flowLength / 2 - 0.24), 0.19, 0]}
        rotation={[0, 0, direction > 0 ? -Math.PI / 2 : Math.PI / 2]}
      >
        <coneGeometry args={[0.12, 0.32, 18]} />
        <meshBasicMaterial
          color={color}
          transparent
          opacity={0.82}
          blending={THREE.AdditiveBlending}
          depthWrite={false}
          toneMapped={false}
        />
      </mesh>
    </group>
  );
};

function facilityMeta(type: IDC.LayoutFacilityType) {
  switch (type) {
    case 'camera':
      return { color: '#8aefff', label: '摄像头' };
    case 'fire_extinguisher':
      return { color: '#ff3d71', label: '灭火器' };
    case 'door':
      return { color: '#ffb000', label: '门禁' };
    case 'sensor':
      return { color: '#16f19a', label: '传感器' };
    case 'crac':
      return { color: '#66d9ff', label: '空调' };
    case 'ups':
      return { color: '#f7d154', label: 'UPS' };
    case 'pdu':
      return { color: '#c58cff', label: 'PDU' };
    default:
      return { color: '#c9fbff', label: '设施' };
  }
}

function canvasRotationToSceneYaw(rotation = 0) {
  const angle = (rotation * Math.PI) / 180;
  return Math.PI - angle;
}

function cameraDirectionFromFacility(facility: IDC.DatacenterLayoutFacilityItem) {
  const yaw = canvasRotationToSceneYaw(facility.rotation || 0);
  const pitch = THREE.MathUtils.degToRad(
    Math.max(-90, Math.min(90, facility.pitch ?? 0)),
  );
  return new THREE.Vector3(
    Math.sin(yaw) * Math.cos(pitch),
    Math.sin(pitch),
    Math.cos(yaw) * Math.cos(pitch),
  ).normalize();
}

const CameraFrustumModel: React.FC = () => {
  const color = '#8fa5ad';
  const geometry = useMemo(() => {
    const nearZ = 0.3;
    const farZ = 1.15;
    const nearWidth = 0.22;
    const nearHeight = 0.14;
    const farWidth = 0.82;
    const farHeight = 0.52;
    const origin = new THREE.Vector3(0, 0, 0);
    const near = [
      new THREE.Vector3(-nearWidth / 2, nearHeight / 2, nearZ),
      new THREE.Vector3(nearWidth / 2, nearHeight / 2, nearZ),
      new THREE.Vector3(nearWidth / 2, -nearHeight / 2, nearZ),
      new THREE.Vector3(-nearWidth / 2, -nearHeight / 2, nearZ),
    ];
    const far = [
      new THREE.Vector3(-farWidth / 2, farHeight / 2, farZ),
      new THREE.Vector3(farWidth / 2, farHeight / 2, farZ),
      new THREE.Vector3(farWidth / 2, -farHeight / 2, farZ),
      new THREE.Vector3(-farWidth / 2, -farHeight / 2, farZ),
    ];
    const segments = [
      origin, far[0], origin, far[1], origin, far[2], origin, far[3],
      near[0], near[1], near[1], near[2], near[2], near[3], near[3], near[0],
      far[0], far[1], far[1], far[2], far[2], far[3], far[3], far[0],
      near[0], far[0], near[1], far[1], near[2], far[2], near[3], far[3],
      origin, new THREE.Vector3(0, 0, farZ),
    ];

    return new THREE.BufferGeometry().setFromPoints(segments);
  }, []);

  return (
    <>
      <lineSegments geometry={geometry}>
        <lineBasicMaterial
          color={color}
          transparent
          opacity={0.9}
          blending={THREE.AdditiveBlending}
          depthWrite={false}
          toneMapped={false}
        />
      </lineSegments>
      <mesh position={[0, 0, 0.74]}>
        <boxGeometry args={[0.58, 0.36, 0.02]} />
        <meshBasicMaterial
          color={color}
          transparent
          opacity={0.08}
          blending={THREE.AdditiveBlending}
          depthWrite={false}
          toneMapped={false}
        />
      </mesh>
    </>
  );
};

const ScreenFacility3D: React.FC<{
  facility: IDC.DatacenterLayoutFacilityItem;
  active: boolean;
  onCameraSelect: (facility: IDC.DatacenterLayoutFacilityItem) => void;
}> = ({
  facility,
  active,
  onCameraSelect,
}) => {
  const lightRef = useRef<THREE.MeshStandardMaterial>(null);
  const sensorGlowRef = useRef<THREE.MeshBasicMaterial>(null);
  const meta = facilityMeta(facility.type);
  const facilityRotationY = canvasRotationToSceneYaw(facility.rotation || 0);
  const cameraHeight = facility.type === 'camera' ? Math.max(0.4, facility.height ?? 2.5) : 0.88;
  const doorWidth = 0.9;
  const doorHeight = 2.1;
  const doorDepth = 0.08;
  const labelHeight =
    facility.type === 'camera' ? cameraHeight + 0.34 : facility.type === 'door' ? doorHeight + 0.34 : 1.02;
  const cameraPitch = THREE.MathUtils.degToRad(
    Math.max(-90, Math.min(90, facility.pitch ?? 0)),
  );

  useFrame(({ clock }) => {
    const pulse = 0.8 + Math.sin(clock.elapsedTime * 3.2) * 0.22;
    if (lightRef.current) {
      lightRef.current.emissiveIntensity = pulse;
    }
    if (sensorGlowRef.current) {
      sensorGlowRef.current.opacity = 0.08 + Math.sin(clock.elapsedTime * 3.2) * 0.035;
    }
  });

  return (
    <group
      position={[facility.x, 0.08, facility.y]}
      onClick={(event) => {
        if (facility.type !== 'camera') return;
        event.stopPropagation();
        onCameraSelect(facility);
      }}
    >
      {!['camera', 'door', 'sensor'].includes(facility.type) && (
        <mesh position={[0, -0.035, 0]} receiveShadow>
          <cylinderGeometry args={[0.22, 0.22, 0.025, 32]} />
          <meshStandardMaterial
            color="#082536"
            emissive={meta.color}
            emissiveIntensity={active ? 0.46 : 0.18}
            transparent
            opacity={0.9}
          />
        </mesh>
      )}

      {facility.type === 'camera' && (
        <group rotation={[0, facilityRotationY, 0]}>
          <group position={[0, cameraHeight, 0.02]} rotation={[-cameraPitch, 0, 0]}>
            <mesh>
              <boxGeometry args={[0.32, 0.2, 0.18]} />
              <meshStandardMaterial
                color="#12394a"
                emissive={meta.color}
                emissiveIntensity={0.25}
                metalness={0.35}
                roughness={0.32}
              />
            </mesh>
            <mesh position={[0, 0, 0.13]}>
              <cylinderGeometry args={[0.07, 0.07, 0.08, 20]} />
              <meshStandardMaterial
                ref={lightRef}
                color={meta.color}
                emissive={meta.color}
                toneMapped={false}
              />
            </mesh>
            <group position={[0, 0, 0.2]}>
              <CameraFrustumModel />
            </group>
          </group>
        </group>
      )}

      {facility.type === 'fire_extinguisher' && (
        <group rotation={[0, facilityRotationY, 0]}>
          <mesh position={[0, 0.28, 0]}>
            <cylinderGeometry args={[0.09, 0.1, 0.48, 24]} />
            <meshStandardMaterial
              color="#9f1239"
              emissive={meta.color}
              emissiveIntensity={0.22}
              metalness={0.18}
              roughness={0.42}
            />
          </mesh>
          <mesh position={[0, 0.55, 0]}>
            <sphereGeometry args={[0.085, 18, 18]} />
            <meshStandardMaterial color="#ef4444" emissive={meta.color} emissiveIntensity={0.18} />
          </mesh>
          <mesh position={[0, 0.63, 0]}>
            <boxGeometry args={[0.18, 0.035, 0.035]} />
            <meshStandardMaterial color="#f8fafc" metalness={0.4} roughness={0.3} />
          </mesh>
        </group>
      )}

      {facility.type === 'door' && (
        <group rotation={[0, facilityRotationY, 0]}>
          <mesh position={[0, doorHeight / 2, 0]}>
            <boxGeometry args={[doorWidth, doorHeight, doorDepth]} />
            <meshStandardMaterial
              color="#2f2a1d"
              emissive={meta.color}
              emissiveIntensity={0.12}
              metalness={0.2}
              roughness={0.5}
            />
          </mesh>
          <lineSegments position={[0, doorHeight / 2, doorDepth / 2 + 0.006]}>
            <edgesGeometry args={[new THREE.BoxGeometry(doorWidth + 0.06, doorHeight + 0.06, 0.02)]} />
            <lineBasicMaterial color={meta.color} transparent opacity={0.95} />
          </lineSegments>
          <mesh position={[doorWidth * 0.32, doorHeight * 0.52, doorDepth / 2 + 0.035]}>
            <boxGeometry args={[0.12, 0.22, 0.035]} />
            <meshStandardMaterial
              ref={lightRef}
              color={meta.color}
              emissive={meta.color}
              toneMapped={false}
            />
          </mesh>
        </group>
      )}

      {facility.type === 'sensor' && (
        <>
          <mesh position={[0, 0.55, 0]}>
            <sphereGeometry args={[0.12, 24, 24]} />
            <meshStandardMaterial
              ref={lightRef}
              color={meta.color}
              emissive={meta.color}
              transparent
              opacity={0.88}
              toneMapped={false}
            />
          </mesh>
          <mesh position={[0, 0.55, 0]}>
            <sphereGeometry args={[0.28, 24, 24]} />
            <meshBasicMaterial
              ref={sensorGlowRef}
              color={meta.color}
              transparent
              opacity={0.09}
              blending={THREE.AdditiveBlending}
              depthWrite={false}
              toneMapped={false}
            />
          </mesh>
        </>
      )}

      {!['camera', 'fire_extinguisher', 'door', 'sensor'].includes(facility.type) && (
        <group rotation={[0, facilityRotationY, 0]}>
          <mesh position={[0, 0.28, 0]}>
            <boxGeometry args={[0.38, 0.5, 0.32]} />
            <meshStandardMaterial
              color="#12394a"
              emissive={meta.color}
              emissiveIntensity={0.2}
              metalness={0.35}
              roughness={0.38}
            />
          </mesh>
        </group>
      )}

      <Billboard position={[0, labelHeight, 0]}>
        <mesh raycast={disableRaycast}>
          <boxGeometry args={[0.9, 0.22, 0.028]} />
          <meshStandardMaterial
            color="#061d2a"
            emissive={meta.color}
            emissiveIntensity={active ? 0.48 : 0.22}
            transparent
            opacity={0.74}
          />
        </mesh>
        <Text
          raycast={disableRaycast}
          position={[0, 0.004, 0.026]}
          fontSize={0.105}
          color="#ffffff"
          anchorX="center"
          anchorY="middle"
          outlineWidth={0.006}
          outlineColor="#00151d"
        >
          {facility.name || meta.label}
        </Text>
      </Billboard>
    </group>
  );
};

const SyncedOrbitControls: React.FC<{
  cameraPosition: [number, number, number];
  target: [number, number, number];
  maxDistance: number;
}> = ({ cameraPosition, target, maxDistance }) => {
  const { camera } = useThree();
  const controlsRef = useRef<any>(null);

  useEffect(() => {
    camera.position.set(...cameraPosition);
    camera.lookAt(...target);
    camera.updateProjectionMatrix();
    controlsRef.current?.target.set(...target);
    controlsRef.current?.update();
  }, [camera, cameraPosition, target]);

  return (
    <OrbitControls
      ref={controlsRef}
      enableDamping
      dampingFactor={0.06}
      minDistance={4}
      maxDistance={maxDistance}
      minPolarAngle={Math.PI / 5}
      maxPolarAngle={Math.PI / 2.25}
      target={target}
    />
  );
};

const ScreenCabinet3D: React.FC<{
  cabinet: IDC.Cabinet;
  devices: IDC.Device[];
  environment?: IDC.CabinetEnvironment;
  telemetryState?: CabinetTelemetrySourceState;
  telemetryWarning?: string;
  position: [number, number, number];
  rotationY: number;
  hovered: boolean;
  selected: boolean;
  showName: boolean;
  onHover: (cabinetId: string | null) => void;
  onConnectionFocus: (cabinetId: string) => void;
  onSelect: (cabinetId: string) => void;
}> = ({
  cabinet,
  devices,
  environment,
  telemetryState,
  telemetryWarning,
  position,
  rotationY,
  hovered,
  selected,
  showName,
  onHover,
  onConnectionFocus,
  onSelect,
}) => {
  const height = 2.72;
  const width = CABINET_LAYOUT_WIDTH;
  const depth = CABINET_LAYOUT_DEPTH;
  const telemetry = telemetryState?.telemetry;
  const cabinetTelemetryWarning =
    telemetryWarning ||
    ((telemetryState?.status === 'offline' || telemetryState?.status === 'configuration_error')
      ? `遥测不可用${telemetryState.lastError ? `：${telemetryState.lastError}` : ''}`
      : undefined);
  const activeStatus =
    telemetryState?.status === 'offline' || telemetryState?.status === 'configuration_error'
      ? 'offline'
      : telemetry?.severity === 'critical'
        ? 'error'
        : telemetry?.severity === 'warning'
          ? 'warning'
          : environment?.status === 'critical'
            ? 'error'
            : cabinet.status;
  const color = statusColor[activeStatus] || statusColor.normal;
  const usage = Math.round((cabinet.usedU / cabinet.uHeight) * 100);
  const onlineDeviceCount = devices.filter((device) => device.status === 'online').length;
  const powerKw = cabinet.currentPower / 1000;
  const slotPanelHeight = height - 0.28;
  const slotHeight = slotPanelHeight / cabinet.uHeight;

  const sortedDevices = useMemo(
    () => [...devices].sort((left, right) => left.startU - right.startU),
    [devices],
  );
  const slotRows = useMemo(
    () =>
      Array.from({ length: cabinet.uHeight }, (_, index) => {
        const u = cabinet.uHeight - index;
        const device = sortedDevices.find(
          (item) => u >= item.startU && u <= item.endU,
        );
        return {
          u,
          device,
          isDeviceStart: Boolean(device && device.startU === u),
        };
      }),
    [cabinet.uHeight, sortedDevices],
  );

  return (
    <group
      position={position}
      rotation={[0, rotationY, 0]}
      onPointerOver={(event) => {
        event.stopPropagation();
        onHover(cabinet.id);
      }}
      onPointerOut={(event) => {
        event.stopPropagation();
        onHover(null);
      }}
      onClick={(event) => {
        event.stopPropagation();
        onConnectionFocus(cabinet.id);
      }}
      onContextMenu={(event) => {
        event.stopPropagation();
        event.nativeEvent.preventDefault();
        onSelect(cabinet.id);
      }}
    >
      <mesh castShadow receiveShadow>
        <boxGeometry args={[width, height, depth]} />
        <meshStandardMaterial
          color={hovered || selected ? '#19b8c8' : '#0b6573'}
          emissive={hovered || selected ? '#34f0ff' : '#087484'}
          emissiveIntensity={selected ? 0.55 : hovered ? 0.42 : 0.18}
          metalness={0.65}
          roughness={0.38}
        />
      </mesh>

      <mesh position={[0, 0, depth / 2 + 0.018]}>
        <boxGeometry args={[width - 0.09, height - 0.14, 0.035]} />
        <meshPhysicalMaterial
          color={hovered || selected ? '#c9fbff' : '#8aefff'}
          transparent
          opacity={hovered || selected ? 0.38 : 0.26}
          metalness={0.2}
          roughness={0.08}
          transmission={0.2}
          emissive={hovered || selected ? '#34f0ff' : '#00c8df'}
          emissiveIntensity={hovered || selected ? 0.28 : 0.08}
        />
      </mesh>

      <CabinetGlow
        color={hovered || selected ? '#34f0ff' : color}
        width={width}
        height={height}
        depth={depth}
      />

      {(hovered || selected) && (
        <lineSegments raycast={disableRaycast} renderOrder={6}>
          <edgesGeometry
            args={[new THREE.BoxGeometry(width + 0.07, height + 0.07, depth + 0.07)]}
          />
          <lineBasicMaterial
            color="#7df9ff"
            transparent
            opacity={0.98}
            depthTest={false}
            toneMapped={false}
          />
        </lineSegments>
      )}

      <group position={[0, 0, depth / 2 + 0.05]}>
        {slotRows.map(({ u, device, isDeviceStart }, index) => {
          const occupied = Boolean(device);
          const y = height / 2 - 0.14 - (index + 0.5) * slotHeight;
          const deviceColor =
            device?.status === 'warning'
              ? '#ffb000'
              : device?.status === 'offline'
                ? '#3b4b5f'
                : device?.status === 'error'
                  ? '#ff3d71'
                  : '#8bdde8';
          const slotColor = occupied
            ? index % 2 === 0
              ? '#6d9eaa'
              : '#5f8f9d'
            : '#071b27';
          const emissiveColor = occupied ? '#0b6b78' : '#00131c';
          const slotWidth = occupied ? width - 0.16 : width - 0.22;
          const highlightedSlotColor = occupied ? '#7ad9e3' : '#125f70';
        return (
          <group key={`${cabinet.id}-u-${u}`} position={[0, y, 0]}>
            <mesh>
              <boxGeometry
                args={[
                  slotWidth,
                  occupied ? slotHeight * 0.88 : slotHeight * 0.52,
                  occupied ? 0.06 : 0.028,
                ]}
              />
              <meshStandardMaterial
                color={hovered || selected ? highlightedSlotColor : slotColor}
                emissive={hovered || selected ? '#19d9ea' : emissiveColor}
                emissiveIntensity={hovered || selected ? 0.75 : occupied ? 0.1 : 0.03}
                metalness={occupied ? 0.35 : 0.12}
                roughness={occupied ? 0.48 : 0.82}
              />
            </mesh>

            {occupied && (
              <>
                <mesh position={[width * 0.31, 0, 0.038]}>
                  <boxGeometry
                    args={[0.075, Math.max(0.01, slotHeight * 0.28), 0.012]}
                  />
                  <meshStandardMaterial
                    color={deviceColor}
                    emissive={deviceColor}
                    emissiveIntensity={0.75}
                  />
                </mesh>
                <mesh position={[-width * 0.32, 0, 0.04]}>
                  <sphereGeometry args={[0.01, 10, 10]} />
                  <meshStandardMaterial
                    color={deviceColor}
                    emissive={deviceColor}
                    emissiveIntensity={1.1}
                  />
                </mesh>
                {isDeviceStart && (
                  <mesh position={[0, slotHeight * 0.24, 0.039]}>
                    <boxGeometry args={[width - 0.24, 0.006, 0.01]} />
                    <meshStandardMaterial
                      color="#c9fbff"
                      emissive="#00eaff"
                      emissiveIntensity={0.35}
                    />
                  </mesh>
                )}
              </>
            )}

            {!occupied && (
              <mesh position={[0, 0, 0.018]}>
                <boxGeometry args={[width - 0.28, 0.004, 0.006]} />
                <meshStandardMaterial
                  color="#123040"
                  emissive="#00eaff"
                  emissiveIntensity={0.04}
                />
              </mesh>
            )}
          </group>
        );
        })}
      </group>

      <StatusLight
        color={color}
        alerting={activeStatus === 'warning' || activeStatus === 'error'}
        position={[width / 2 - 0.08, height / 2 + 0.035, depth / 2 + 0.02]}
      />

      {showName && (
        <Billboard position={[0, height / 2 + 0.35, depth / 2 - 0.04]}>
          <mesh raycast={disableRaycast}>
            <boxGeometry args={[1.3, 0.28, 0.035]} />
            <meshStandardMaterial
              color="#062936"
              emissive={color}
              emissiveIntensity={0.22}
              transparent
              opacity={0.75}
            />
          </mesh>
          <Text
            raycast={disableRaycast}
            position={[0, 0.005, 0.03]}
            fontSize={0.13}
            color={color}
            anchorX="center"
            anchorY="middle"
            outlineWidth={0.005}
            outlineColor="#00151d"
            maxWidth={1.18}
          >
            {cabinet.name || cabinet.code}
          </Text>
        </Billboard>
      )}

      {selected && (
        <Billboard position={[0.75, 0.65, depth / 2 + 0.18]}>
          <Html transform distanceFactor={4.6} zIndexRange={[80, 0]}>
            <div
              style={{
                minWidth: 210,
                padding: '14px 16px',
                color: '#dffaff',
                background: 'rgba(1, 15, 24, 0.92)',
                border: '1px solid rgba(0, 240, 255, 0.55)',
                borderRadius: 8,
                boxShadow: '0 0 22px rgba(0, 240, 255, 0.25)',
                fontSize: 12,
                lineHeight: 1.7,
                pointerEvents: 'auto',
              }}
              data-cabinet-summary-card
            >
              <div
                onClick={(event) => {
                  event.stopPropagation();
                  history.push(`/cabinet3d?id=${cabinet.id}`);
                }}
                style={{
                  color,
                  cursor: 'pointer',
                  fontSize: 16,
                  fontWeight: 700,
                  marginBottom: 4,
                  pointerEvents: 'auto',
                  textDecoration: 'underline',
                  textUnderlineOffset: 3,
                }}
                title="查看机柜详情"
              >
                {cabinet.name || cabinet.code}
              </div>
              <div style={detailSectionStyle}>
                <div style={detailSectionTitleStyle}>机柜概要</div>
                <div>
                  状态: <span style={{ color }}>{statusText[activeStatus] || activeStatus}</span>
                </div>
                <div>设备数量: {devices.length} 台</div>
                <div>U位占用: {cabinet.usedU}/{cabinet.uHeight}U（{usage}%）</div>
                {cabinetTelemetryWarning && (
                  <div style={{ color: '#ffb000' }}>{cabinetTelemetryWarning}</div>
                )}
              </div>

              <div style={detailSectionStyle}>
                <div style={detailSectionTitleStyle}>机柜遥测</div>
                {telemetry ? (
                  <>
                    <div>温度: {telemetry.temperatureC}℃</div>
                    <div>湿度: {telemetry.humidityRH}%RH</div>
                    <div>功耗: {(telemetry.activePowerW / 1000).toFixed(2)} kW</div>
                    <div>
                      电气: {telemetry.voltageV.toFixed(1)} V / {telemetry.currentA.toFixed(2)} A
                    </div>
                    <div>负载: {telemetry.loadPercent.toFixed(1)}%</div>
                    <div>柜门: {telemetry.doorOpen ? '打开' : '关闭'}</div>
                    <div>告警码: {telemetry.alarmCode}</div>
                    <div>更新: {new Date(telemetry.timestamp).toLocaleTimeString('zh-CN')}</div>
                  </>
                ) : (
                  <div style={detailMutedStyle}>
                    暂无实时遥测（当前功耗 {powerKw.toFixed(2)} kW）
                  </div>
                )}
              </div>

              <div style={detailSectionStyle}>
                <div style={detailSectionTitleStyle}>主机遥测</div>
                <div>CPU使用率: {Math.min(98, usage + 8)}%</div>
                <div>在线设备: {onlineDeviceCount}/{devices.length} 台</div>
              </div>

              <div style={detailSectionStyle}>
                <div style={detailSectionTitleStyle}>采集端点</div>
                {telemetryState ? (
                  <>
                    <div>采集: {telemetryState.status}</div>
                    <div>
                      模式: {telemetryState.collectionMode === 'high' ? '高频' : '低频'}（
                      {telemetryState.pollIntervalSeconds} 秒）
                    </div>
                    <div>协议: Modbus TCP</div>
                    <div style={{ wordBreak: 'break-all' }}>
                      端点: {telemetryState.source.host}:{telemetryState.source.port}
                    </div>
                    <div>Unit ID: {telemetryState.source.unitId}</div>
                    {telemetryState.status !== 'online' && telemetryState.lastError && (
                      <div>原因: {telemetryState.lastError}</div>
                    )}
                  </>
                ) : (
                  <div style={detailMutedStyle}>未配置采集端点</div>
                )}
              </div>
            </div>
          </Html>
        </Billboard>
      )}
    </group>
  );
};

export const ScreenDatacenterScene: React.FC<ScreenDatacenterSceneProps> = ({
  layout,
  cabinets,
  devices,
  cabinetEnvironments,
  cabinetTelemetry,
  telemetryWarning,
  onSelectedCabinetChange,
  connections,
  connectionTypes,
  showConnections,
  showCabinetNames,
  showHeatmap,
  enabledConnectionTypes,
}) => {
  const [hoveredCabinetId, setHoveredCabinetId] = useState<string | null>(null);
  const [selectedCabinetId, setSelectedCabinetId] = useState<string | null>(null);
  const [connectionFocusCabinetId, setConnectionFocusCabinetId] = useState<string | null>(null);
  const [activeCameraFacilityId, setActiveCameraFacilityId] = useState<string | null>(null);
  const selectCabinet = (cabinetId: string | null) => {
    setSelectedCabinetId(cabinetId);
    onSelectedCabinetChange(cabinetId);
  };

  useEffect(() => {
    if (!selectedCabinetId) return undefined;

    const closeSummaryCard = (event: PointerEvent) => {
      if (event.button !== 0) return;
      if ((event.target as Element | null)?.closest('[data-cabinet-summary-card]')) return;
      setSelectedCabinetId(null);
      onSelectedCabinetChange(null);
    };

    document.addEventListener('pointerdown', closeSummaryCard, true);
    return () => document.removeEventListener('pointerdown', closeSummaryCard, true);
  }, [selectedCabinetId, onSelectedCabinetChange]);
  const floorSize = useMemo(
    () => ({
      width: Math.max(1, layout.canvasWidth || 60),
      height: Math.max(1, layout.canvasHeight || 40),
    }),
    [layout.canvasHeight, layout.canvasWidth],
  );
  const floorCenter = useMemo<[number, number, number]>(
    () => [floorSize.width / 2, 0, floorSize.height / 2],
    [floorSize.height, floorSize.width],
  );

  const layoutByCabinetId = useMemo(
    () => new Map(layout.cabinets.map((item) => [item.cabinetId, item] as const)),
    [layout.cabinets],
  );
  const cabinetPlacementKey = cabinets
    .map((cabinet) => `${cabinet.id}:${cabinet.row}:${cabinet.column}`)
    .join('|');
  const cabinetViewPoints = useMemo(
    () =>
      cabinets.map((cabinet) => {
        const layoutItem = layoutByCabinetId.get(cabinet.id);
        return {
          x: layoutItem
            ? layoutItem.x + CABINET_LAYOUT_WIDTH / 2
            : (cabinet.column - 1) * 1.2 + CABINET_LAYOUT_WIDTH / 2,
          z: layoutItem
            ? layoutItem.y + CABINET_LAYOUT_DEPTH / 2
            : (cabinet.row - 1) * 1.6 + CABINET_LAYOUT_DEPTH / 2,
        };
      }),
    [cabinetPlacementKey, layoutByCabinetId],
  );
  const devicesByCabinetId = useMemo(() => {
    const map = new Map<string, IDC.Device[]>();
    for (const device of devices) {
      const items = map.get(device.cabinetId) || [];
      items.push(device);
      map.set(device.cabinetId, items);
    }
    return map;
  }, [devices]);
  const envByCabinetId = useMemo(
    () => new Map(cabinetEnvironments.map((item) => [item.cabinetId, item] as const)),
    [cabinetEnvironments],
  );
  const cabinetPositions = useMemo(() => {
    const map = new Map<string, CabinetScenePosition>();
    cabinets.forEach((cabinet) => {
      const layoutItem = layoutByCabinetId.get(cabinet.id);
      map.set(cabinet.id, {
        x: layoutItem
          ? layoutItem.x + CABINET_LAYOUT_WIDTH / 2
          : (cabinet.column - 1) * 1.2 + CABINET_LAYOUT_WIDTH / 2,
        z: layoutItem
          ? layoutItem.y + CABINET_LAYOUT_DEPTH / 2
          : (cabinet.row - 1) * 1.6 + CABINET_LAYOUT_DEPTH / 2,
      });
    });
    return map;
  }, [cabinets, layoutByCabinetId]);
  const cabinetHeatmapPoints = useMemo(
    () =>
      cabinets.flatMap((cabinet) => {
        const position = cabinetPositions.get(cabinet.id);
        const temperature =
          cabinetTelemetry[cabinet.id]?.telemetry?.temperatureC ??
          envByCabinetId.get(cabinet.id)?.avgTemperature;
        if (!position || temperature === undefined || !Number.isFinite(temperature)) return [];
        return [{ cabinetId: cabinet.id, temperature, ...position }];
      }),
    [cabinetPositions, cabinetTelemetry, cabinets, envByCabinetId],
  );
  const cabinetConnectionLines = useMemo(() => {
    const deviceCabinetIdByDeviceId = new Map(
      devices.map((device) => [device.id, device.cabinetId] as const),
    );
    const colorByConnectionType = new Map(
      connectionTypes.map((item) => [item.value, item.color] as const),
    );
    const connectionByPairAndType = new Map<
      string,
      {
        connection: IDC.Connection;
        sourceCabinetId: string;
        targetCabinetId: string;
        pair: string;
      }
    >();

    connections.forEach((connection) => {
        const sourceCabinetId = deviceCabinetIdByDeviceId.get(connection.sourceDeviceId);
        const targetCabinetId = deviceCabinetIdByDeviceId.get(connection.targetDeviceId);
        if (
          !sourceCabinetId ||
          !targetCabinetId ||
          sourceCabinetId === targetCabinetId ||
          !cabinetPositions.has(sourceCabinetId) ||
          !cabinetPositions.has(targetCabinetId)
        ) {
          return;
        }

        const pair = [sourceCabinetId, targetCabinetId].sort().join('__');
        const key = `${pair}__${connection.connectionType}`;
        if (connectionByPairAndType.has(key)) {
          return;
        }

        connectionByPairAndType.set(key, {
          connection,
          sourceCabinetId,
          targetCabinetId,
          pair,
        });
    });

    const linesByPair = new Map<string, number>();
    Array.from(connectionByPairAndType.values()).forEach(({ pair }) => {
      linesByPair.set(pair, (linesByPair.get(pair) || 0) + 1);
    });
    const indexByPair = new Map<string, number>();

    return Array.from(connectionByPairAndType.values()).map(({
      connection,
      sourceCabinetId,
      targetCabinetId,
      pair,
    }) => {
      const index = indexByPair.get(pair) || 0;
      indexByPair.set(pair, index + 1);
      return {
        id: `${pair}-${connection.connectionType}`,
        sourceCabinetId,
        targetCabinetId,
        connectionType: connection.connectionType,
        color: colorByConnectionType.get(connection.connectionType) || connection.cableColor || '#00eaff',
        index,
        total: linesByPair.get(pair) || 1,
      };
    });
  }, [cabinetPositions, connectionTypes, connections, devices]);
  const filteredConnectionLines = useMemo(() => {
    if (!showConnections) return [];
    const enabledTypes = new Set(enabledConnectionTypes);
    const visibleLines = cabinetConnectionLines.filter((line) =>
      enabledTypes.has(line.connectionType),
    );
    if (!connectionFocusCabinetId) return visibleLines;
    return visibleLines.filter(
      (line) =>
        line.sourceCabinetId === connectionFocusCabinetId ||
        line.targetCabinetId === connectionFocusCabinetId,
    );
  }, [cabinetConnectionLines, connectionFocusCabinetId, enabledConnectionTypes, showConnections]);
  const sceneView = useMemo(() => {
    const span = Math.max(floorSize.width, floorSize.height, 6);
    const distance = Math.min(Math.max(span * 0.62, 12), 48);

    if (!cabinetViewPoints.length) {
      return {
        cameraPosition: [
          floorCenter[0] + distance * 0.68,
          distance * 0.78,
          floorCenter[2] + distance,
        ] as [number, number, number],
        target: [floorCenter[0], 1.1, floorCenter[2]] as [number, number, number],
        maxDistance: distance * 1.8,
      };
    }

    const minX = Math.min(0, ...cabinetViewPoints.map((item) => item.x));
    const maxX = Math.max(floorSize.width, ...cabinetViewPoints.map((item) => item.x));
    const minZ = Math.min(0, ...cabinetViewPoints.map((item) => item.z));
    const maxZ = Math.max(floorSize.height, ...cabinetViewPoints.map((item) => item.z));
    const centerX = (minX + maxX) / 2;
    const centerZ = (minZ + maxZ) / 2;
    const viewSpan = Math.max(maxX - minX, maxZ - minZ, 6);
    const viewDistance = Math.min(Math.max(viewSpan * 0.62, 12), 48);

    return {
      cameraPosition: [
        centerX + viewDistance * 0.68,
        viewDistance * 0.78,
        centerZ + viewDistance,
      ] as [number, number, number],
      target: [centerX, 1.1, centerZ] as [number, number, number],
      maxDistance: viewDistance * 1.8,
    };
  }, [cabinetViewPoints, floorCenter, floorSize]);
  const activeCameraFacility = useMemo(
    () =>
      (layout.facilities || []).find(
        (facility) => facility.id === activeCameraFacilityId && facility.type === 'camera',
      ) || null,
    [activeCameraFacilityId, layout.facilities],
  );
  const effectiveSceneView = useMemo(() => {
    if (!activeCameraFacility) return sceneView;

    const cameraHeight = Math.max(0.4, activeCameraFacility.height ?? 2.5);
    const forward = cameraDirectionFromFacility(activeCameraFacility);
    const cameraPosition = new THREE.Vector3(
      activeCameraFacility.x,
      cameraHeight + 0.08,
      activeCameraFacility.y,
    ).add(forward.clone().multiplyScalar(0.26));
    const target = cameraPosition.clone().add(forward.multiplyScalar(10));

    return {
      cameraPosition: cameraPosition.toArray() as [number, number, number],
      target: target.toArray() as [number, number, number],
      maxDistance: sceneView.maxDistance,
    };
  }, [activeCameraFacility, sceneView]);
  const balancedLightSources = useMemo(
    () => [
      {
        id: 'left-balanced-light',
        position: [floorSize.width * 0.25, 3.4, floorSize.height * 0.5] as [
          number,
          number,
          number,
        ],
      },
      {
        id: 'right-balanced-light',
        position: [floorSize.width * 0.75, 3.4, floorSize.height * 0.5] as [
          number,
          number,
          number,
        ],
      },
    ],
    [floorSize.height, floorSize.width],
  );

  return (
    <>
      <color attach="background" args={['#0b1e2e']} />
      <fog attach="fog" args={['#0b1e2e', 10, effectiveSceneView.maxDistance * 1.25]} />
      <PerspectiveCamera makeDefault position={effectiveSceneView.cameraPosition} fov={48} />
      <ambientLight intensity={0.78} color="#d8fbff" />
      <directionalLight position={[4, 7, 4]} intensity={2.4} color="#ffffff" castShadow />
      {balancedLightSources.map((light, index) => (
        <pointLight
          key={`${light.id}-point`}
          position={light.position}
          intensity={index === 0 ? 3.2 : 2.45}
          color={index === 0 ? '#7df6ff' : '#c7fbff'}
          distance={Math.max(floorSize.width, floorSize.height) * 0.62}
        />
      ))}
      <spotLight position={[0, 6, 4]} angle={0.58} penumbra={0.68} intensity={2.1} color="#f2ffff" />

      <mesh
        rotation={[-Math.PI / 2, 0, 0]}
        position={[floorCenter[0], -0.025, floorCenter[2]]}
        receiveShadow
        onClick={() => {
          selectCabinet(null);
          setConnectionFocusCabinetId(null);
          setActiveCameraFacilityId(null);
        }}
      >
        <planeGeometry args={[floorSize.width, floorSize.height]} />
        <meshStandardMaterial
          color="#174155"
          metalness={0.24}
          roughness={0.46}
          emissive="#0b3144"
          emissiveIntensity={0.48}
        />
      </mesh>

      <Grid
        args={[floorSize.width, floorSize.height]}
        position={[floorCenter[0], -0.018, floorCenter[2]]}
        infiniteGrid={false}
        cellSize={5}
        sectionSize={5}
        fadeDistance={sceneView.maxDistance}
        fadeStrength={0.7}
        cellColor="#79aaba"
        sectionColor="#b8e8f0"
      />

      <group position={[0, 0.006, 0]}>
        <mesh position={[floorSize.width / 2, 0, 0]}>
          <boxGeometry args={[floorSize.width, 0.018, 0.12]} />
          <meshStandardMaterial color="#00f0ff" emissive="#00bcd4" emissiveIntensity={0.7} />
        </mesh>
        <mesh position={[floorSize.width / 2, 0, floorSize.height]}>
          <boxGeometry args={[floorSize.width, 0.018, 0.12]} />
          <meshStandardMaterial color="#00f0ff" emissive="#00bcd4" emissiveIntensity={0.7} />
        </mesh>
        <mesh position={[0, 0, floorSize.height / 2]}>
          <boxGeometry args={[0.12, 0.018, floorSize.height]} />
          <meshStandardMaterial color="#00f0ff" emissive="#00bcd4" emissiveIntensity={0.7} />
        </mesh>
        <mesh position={[floorSize.width, 0, floorSize.height / 2]}>
          <boxGeometry args={[0.12, 0.018, floorSize.height]} />
          <meshStandardMaterial color="#00f0ff" emissive="#00bcd4" emissiveIntensity={0.7} />
        </mesh>
        {[
          [0, 0],
          [floorSize.width, 0],
          [0, floorSize.height],
          [floorSize.width, floorSize.height],
        ].map(([x, z]) => (
          <mesh key={`${x}-${z}`} position={[x, 0.09, z]}>
            <boxGeometry args={[0.28, 0.18, 0.28]} />
            <meshStandardMaterial color="#b9fbff" emissive="#00eaff" emissiveIntensity={0.9} />
          </mesh>
        ))}
      </group>

      <Text
        position={[floorCenter[0], 0.035, -0.65]}
        rotation={[-Math.PI / 2, 0, 0]}
        fontSize={Math.max(0.45, Math.min(floorSize.width, floorSize.height) * 0.03)}
        color="#c9fbff"
        anchorX="center"
        anchorY="middle"
        outlineWidth={0.012}
        outlineColor="#002433"
      >
        {`${floorSize.width}m × ${floorSize.height}m`}
      </Text>

      {(layout.zones || []).map((zone) => {
        const color = zoneColor(zone.type);
        const rotationY = ((zone.rotation || 0) * Math.PI) / 180;
        return (
          <group key={zone.id}>
            <mesh
              rotation={[-Math.PI / 2, rotationY, 0]}
              position={[zone.x + zone.width / 2, -0.014, zone.y + zone.height / 2]}
              receiveShadow
            >
              <planeGeometry args={[zone.width, zone.height]} />
              <meshStandardMaterial
                color={color}
                emissive={color}
                emissiveIntensity={0.18}
                transparent
                opacity={0.28}
                metalness={0}
                roughness={0.8}
              />
            </mesh>
            <Text
              position={[zone.x + zone.width / 2, 0.028, zone.y + zone.height / 2]}
              rotation={[-Math.PI / 2, 0, rotationY]}
              fontSize={Math.max(0.22, Math.min(zone.width, zone.height) * 0.16)}
              color="#f2ffff"
              anchorX="center"
              anchorY="middle"
              outlineWidth={0.01}
              outlineColor="#00151d"
            >
              {zone.name || zoneLabel(zone.type)}
            </Text>
            <AisleAirflow zone={zone} />
          </group>
        );
      })}

      {showConnections && (
        <CabinetConnectionLayer
          lines={filteredConnectionLines}
          cabinetPositions={cabinetPositions}
        />
      )}

      {showHeatmap && <CabinetHeatmapLayer points={cabinetHeatmapPoints} />}

      {cabinets.map((cabinet) => {
        const layoutItem = layoutByCabinetId.get(cabinet.id);
        const position = cabinetPositions.get(cabinet.id);
        if (!position) return null;
        const rotationY = (((layoutItem?.rotation || 0) * Math.PI) / 180);
        return (
          <ScreenCabinet3D
            key={cabinet.id}
            cabinet={cabinet}
            devices={devicesByCabinetId.get(cabinet.id) || []}
            environment={envByCabinetId.get(cabinet.id)}
            telemetryState={cabinetTelemetry[cabinet.id]}
            telemetryWarning={telemetryWarning}
            position={[position.x, 1.36, position.z]}
            rotationY={rotationY}
            hovered={hoveredCabinetId === cabinet.id}
            selected={selectedCabinetId === cabinet.id}
            showName={showCabinetNames}
            onHover={setHoveredCabinetId}
            onConnectionFocus={setConnectionFocusCabinetId}
            onSelect={selectCabinet}
          />
        );
      })}

      {(layout.facilities || []).map((facility) => (
        <ScreenFacility3D
          key={facility.id}
          facility={facility}
          active={activeCameraFacilityId === facility.id}
          onCameraSelect={(item) => {
            selectCabinet(null);
            setActiveCameraFacilityId(item.id);
          }}
        />
      ))}

      <SyncedOrbitControls
        cameraPosition={effectiveSceneView.cameraPosition}
        target={effectiveSceneView.target}
        maxDistance={effectiveSceneView.maxDistance}
      />
    </>
  );
};
