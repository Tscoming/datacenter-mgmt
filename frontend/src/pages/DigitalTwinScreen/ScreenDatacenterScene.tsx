import {
  Billboard,
  Grid,
  Html,
  OrbitControls,
  PerspectiveCamera,
  Text,
} from '@react-three/drei';
import { useFrame, useThree } from '@react-three/fiber';
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
              <div style={{ color, fontSize: 16, fontWeight: 700, marginBottom: 4 }}>机柜 {cabinet.code}</div>
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

  return (
    <>
      <color attach="background" args={['#0b1e2e']} />
      <fog attach="fog" args={['#0b1e2e', 10, sceneView.maxDistance * 1.25]} />
      <PerspectiveCamera makeDefault position={sceneView.cameraPosition} fov={48} />
      <ambientLight intensity={0.78} color="#d8fbff" />
      <directionalLight position={[4, 7, 4]} intensity={2.4} color="#ffffff" castShadow />
      <pointLight position={[-4, 3.2, 1.4]} intensity={3.2} color="#7df6ff" distance={10} />
      <pointLight position={[3.4, 2.8, -2]} intensity={2.45} color="#c7fbff" distance={10} />
      <spotLight position={[0, 6, 4]} angle={0.58} penumbra={0.68} intensity={2.1} color="#f2ffff" />

      <mesh
        rotation={[-Math.PI / 2, 0, 0]}
        position={[floorCenter[0], -0.025, floorCenter[2]]}
        receiveShadow
        onClick={() => setSelectedCabinetId(null)}
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
        {`画布 ${floorSize.width}m × ${floorSize.height}m`}
      </Text>

      {(layout.zones || []).map((zone) => {
        const color = zoneColor(zone.type);
        return (
          <mesh
            key={zone.id}
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

      <SyncedOrbitControls
        cameraPosition={sceneView.cameraPosition}
        target={sceneView.target}
        maxDistance={sceneView.maxDistance}
      />
    </>
  );
};
