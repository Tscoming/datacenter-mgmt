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

interface ScreenDatacenterSceneProps {
  layout: IDC.DatacenterLayout;
  cabinets: IDC.Cabinet[];
  devices: IDC.Device[];
  cabinetEnvironments: IDC.CabinetEnvironment[];
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

const zoneColor = (type: IDC.LayoutZoneType) => {
  if (type === 'hot_aisle') return '#ff3d71';
  if (type === 'cold_aisle') return '#00d9ff';
  if (type === 'restricted') return '#ffb000';
  return '#16f19a';
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

const CameraFrustumModel: React.FC<{ color: string }> = ({ color }) => {
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
  const meta = facilityMeta(facility.type);
  const facilityRotationY = canvasRotationToSceneYaw(facility.rotation || 0);
  const cameraHeight = facility.type === 'camera' ? Math.max(0.4, facility.height ?? 2.5) : 0.88;
  const cameraPitch = THREE.MathUtils.degToRad(
    Math.max(-90, Math.min(90, facility.pitch ?? 0)),
  );

  useFrame(({ clock }) => {
    if (!lightRef.current) return;
    lightRef.current.emissiveIntensity = 0.8 + Math.sin(clock.elapsedTime * 3.2) * 0.22;
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

      {facility.type === 'camera' && (
        <group rotation={[0, facilityRotationY, 0]}>
          <mesh position={[0, cameraHeight / 2, 0]}>
            <cylinderGeometry args={[0.025, 0.025, Math.max(0.3, cameraHeight - 0.16), 12]} />
            <meshStandardMaterial color="#557283" metalness={0.45} roughness={0.38} />
          </mesh>
          <mesh position={[0, cameraHeight - 0.12, 0]}>
            <sphereGeometry args={[0.095, 18, 18]} />
            <meshStandardMaterial
              color="#34515f"
              emissive={meta.color}
              emissiveIntensity={0.12}
              metalness={0.35}
              roughness={0.4}
            />
          </mesh>
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
              <CameraFrustumModel color={meta.color} />
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
          <mesh position={[0, 0.42, 0]}>
            <boxGeometry args={[0.52, 0.78, 0.045]} />
            <meshStandardMaterial
              color="#2f2a1d"
              emissive={meta.color}
              emissiveIntensity={0.12}
              metalness={0.2}
              roughness={0.5}
            />
          </mesh>
          <lineSegments position={[0, 0.42, 0.028]}>
            <edgesGeometry args={[new THREE.BoxGeometry(0.56, 0.82, 0.055)]} />
            <lineBasicMaterial color={meta.color} transparent opacity={0.95} />
          </lineSegments>
          <mesh position={[0.18, 0.43, 0.055]}>
            <boxGeometry args={[0.08, 0.14, 0.028]} />
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
          <mesh position={[0, 0.28, 0]}>
            <cylinderGeometry args={[0.018, 0.018, 0.42, 12]} />
            <meshStandardMaterial color="#42606d" metalness={0.35} roughness={0.4} />
          </mesh>
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

      <Billboard position={[0, facility.type === 'camera' ? cameraHeight + 0.34 : 1.02, 0]}>
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
          color={meta.color}
          anchorX="center"
          anchorY="middle"
          outlineWidth={0.004}
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
  position: [number, number, number];
  rotationY: number;
  hovered: boolean;
  selected: boolean;
  onHover: (cabinetId: string | null) => void;
  onSelect: (cabinetId: string) => void;
}> = ({
  cabinet,
  devices,
  environment,
  position,
  rotationY,
  hovered,
  selected,
  onHover,
  onSelect,
}) => {
  const height = 2.72;
  const width = CABINET_LAYOUT_WIDTH;
  const depth = CABINET_LAYOUT_DEPTH;
  const activeStatus = environment?.status === 'critical' ? 'error' : cabinet.status;
  const color = statusColor[activeStatus] || statusColor.normal;
  const usage = Math.round((cabinet.usedU / cabinet.uHeight) * 100);
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
          color="#8aefff"
          transparent
          opacity={0.26}
          metalness={0.2}
          roughness={0.08}
          transmission={0.2}
          emissive="#00c8df"
          emissiveIntensity={0.08}
        />
      </mesh>

      <CabinetGlow color={color} width={width} height={height} depth={depth} />

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
                color={slotColor}
                emissive={emissiveColor}
                emissiveIntensity={occupied ? 0.1 : 0.03}
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

      <Billboard position={[0, height / 2 + 0.35, depth / 2 - 0.04]}>
        <mesh raycast={disableRaycast}>
          <boxGeometry args={[1.05, 0.28, 0.035]} />
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
          fontSize={0.15}
          color={color}
          anchorX="center"
          anchorY="middle"
          outlineWidth={0.005}
          outlineColor="#00151d"
        >
          {cabinet.code || cabinet.name}
        </Text>
      </Billboard>

      {selected && (
        <Billboard position={[0.75, 0.65, depth / 2 + 0.18]}>
          <Html transform distanceFactor={4.6} zIndexRange={[80, 0]}>
            <div
              style={{
                minWidth: 164,
                padding: '14px 16px',
                color: '#dffaff',
                background: 'rgba(1, 15, 24, 0.92)',
                border: '1px solid rgba(0, 240, 255, 0.55)',
                borderRadius: 8,
                boxShadow: '0 0 22px rgba(0, 240, 255, 0.25)',
                fontSize: 12,
                lineHeight: 1.7,
                pointerEvents: 'none',
              }}
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
              <div>
                状态: <span style={{ color }}>{statusText[activeStatus] || activeStatus}</span>
              </div>
              <div>CPU: {Math.min(98, usage + 8)}%</div>
              <div>温度: {environment?.avgTemperature ?? 0}℃</div>
              <div>设备: {devices.length}台</div>
              <div>功耗: {powerKw.toFixed(1)} kW</div>
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
}) => {
  const [hoveredCabinetId, setHoveredCabinetId] = useState<string | null>(null);
  const [selectedCabinetId, setSelectedCabinetId] = useState<string | null>(null);
  const [activeCameraFacilityId, setActiveCameraFacilityId] = useState<string | null>(null);
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
  const sceneView = useMemo(() => {
    const span = Math.max(floorSize.width, floorSize.height, 6);
    const distance = Math.min(Math.max(span * 0.62, 12), 48);

    if (!cabinets.length) {
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

    const points = cabinets.map((cabinet) => {
      const layoutItem = layoutByCabinetId.get(cabinet.id);
      return {
        x: layoutItem
          ? layoutItem.x + CABINET_LAYOUT_WIDTH / 2
          : (cabinet.column - 1) * 1.2 + CABINET_LAYOUT_WIDTH / 2,
        z: layoutItem
          ? layoutItem.y + CABINET_LAYOUT_DEPTH / 2
          : (cabinet.row - 1) * 1.6 + CABINET_LAYOUT_DEPTH / 2,
      };
    });
    const minX = Math.min(0, ...points.map((item) => item.x));
    const maxX = Math.max(floorSize.width, ...points.map((item) => item.x));
    const minZ = Math.min(0, ...points.map((item) => item.z));
    const maxZ = Math.max(floorSize.height, ...points.map((item) => item.z));
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
  }, [cabinets, floorCenter, floorSize, layoutByCabinetId]);
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
          setSelectedCabinetId(null);
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
        return (
          <group key={zone.id}>
            <mesh
              rotation={[-Math.PI / 2, ((zone.rotation || 0) * Math.PI) / 180, 0]}
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
            <AisleAirflow zone={zone} />
          </group>
        );
      })}

      {cabinets.map((cabinet) => {
        const layoutItem = layoutByCabinetId.get(cabinet.id);
        const x = layoutItem
          ? layoutItem.x + CABINET_LAYOUT_WIDTH / 2
          : (cabinet.column - 1) * 1.2 + CABINET_LAYOUT_WIDTH / 2;
        const z = layoutItem
          ? layoutItem.y + CABINET_LAYOUT_DEPTH / 2
          : (cabinet.row - 1) * 1.6 + CABINET_LAYOUT_DEPTH / 2;
        const rotationY = (((layoutItem?.rotation || 0) * Math.PI) / 180);
        return (
          <ScreenCabinet3D
            key={cabinet.id}
            cabinet={cabinet}
            devices={devicesByCabinetId.get(cabinet.id) || []}
            environment={envByCabinetId.get(cabinet.id)}
            position={[x, 1.36, z]}
            rotationY={rotationY}
            hovered={hoveredCabinetId === cabinet.id}
            selected={selectedCabinetId === cabinet.id}
            onHover={setHoveredCabinetId}
            onSelect={setSelectedCabinetId}
          />
        );
      })}

      {(layout.facilities || []).map((facility) => (
        <ScreenFacility3D
          key={facility.id}
          facility={facility}
          active={activeCameraFacilityId === facility.id}
          onCameraSelect={(item) => {
            setSelectedCabinetId(null);
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
