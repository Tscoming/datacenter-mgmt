import React, { useEffect, useMemo, useRef } from 'react';
import * as THREE from 'three';
import {
  type SinePulseParams,
  useAnimationRegistry,
} from '../AnimationRegistry';
import { FrontPortPanel, RearPortPanel } from '../PortRenderer3D';
import { DeviceTooltip } from './shared/DeviceTooltip';
import {
  type DeviceModelProps,
  deviceStatusColors,
} from './shared/deviceUtils';

export const StorageModel: React.FC<DeviceModelProps> = ({
  device,
  template,
  ports = [],
  position,
  height,
  width,
  depth,
  selected,
  hovered,
  showRear = false,
  showTooltip = true,
  onClick,
  onDoubleClick,
  onPointerOver,
  onPointerOut,
}) => {
  const groupRef = useRef<THREE.Group>(null);
  const statusMaterialRef = useRef<THREE.MeshStandardMaterial | null>(null);
  const animIdRef = useRef<string | null>(null);
  const pulseParamsRef = useRef<SinePulseParams>({
    enabled: true,
    base: 0.5,
    amp: 0.5,
    speed: 3,
  });
  const registry = useAnimationRegistry();
  const status =
    deviceStatusColors[device.status] || deviceStatusColors.offline;
  const isWarning = device.status === 'warning' || device.status === 'error';

  useEffect(() => {
    const mat = statusMaterialRef.current;
    if (!mat) return;
    if (isWarning) {
      if (!animIdRef.current) {
        animIdRef.current = registry.register(mat, pulseParamsRef);
      }
      return;
    }
    if (animIdRef.current) {
      registry.unregister(animIdRef.current);
      animIdRef.current = null;
    }
    mat.emissiveIntensity = 0.3;
  }, [isWarning, registry]);

  useEffect(() => {
    return () => {
      if (animIdRef.current) registry.unregister(animIdRef.current);
      animIdRef.current = null;
    };
  }, [registry]);

  // 磁盘托架
  const diskBays = useMemo(() => {
    const bays: React.ReactNode[] = [];
    const cols = Math.min(12, Math.floor(width / 0.04));
    const rows = Math.max(1, Math.floor(height / 0.025));
    const startX = -width / 2 + 0.03;
    const startY = height / 2 - 0.02;

    for (let row = 0; row < rows; row++) {
      for (let col = 0; col < cols; col++) {
        const isActive = Math.random() > 0.2;
        bays.push(
          <group
            key={`${row}-${col}`}
            position={[
              startX + col * 0.038,
              startY - row * 0.025,
              depth / 2 + 0.003,
            ]}
          >
            {/* 磁盘托架 */}
            <mesh>
              <boxGeometry args={[0.032, 0.02, 0.004]} />
              <meshStandardMaterial
                color="#222"
                metalness={0.6}
                roughness={0.3}
              />
            </mesh>
            {/* 活动LED */}
            <mesh position={[0.01, 0.006, 0.002]}>
              <boxGeometry args={[0.006, 0.003, 0.001]} />
              <meshStandardMaterial
                color={isActive ? '#00ff00' : '#333'}
                emissive={isActive ? '#00ff00' : '#000'}
                emissiveIntensity={isActive ? 0.8 : 0}
              />
            </mesh>
          </group>,
        );
      }
    }
    return bays;
  }, [width, height, depth]);

  return (
    <group ref={groupRef} position={position}>
      {/* 存储主体 */}
      <mesh
        onClick={onClick}
        onDoubleClick={onDoubleClick}
        onPointerOver={onPointerOver}
        onPointerOut={onPointerOut}
      >
        <boxGeometry args={[width, height, depth]} />
        <meshStandardMaterial
          color={hovered ? '#6a5acd' : '#483d8b'}
          metalness={0.4}
          roughness={0.5}
        />
      </mesh>

      {/* 前面板 */}
      <mesh position={[0, 0, depth / 2 + 0.001]}>
        <boxGeometry args={[width - 0.01, height - 0.005, 0.003]} />
        <meshStandardMaterial color="#1a1525" metalness={0.3} roughness={0.6} />
      </mesh>

      {/* 磁盘托架 */}
      {diskBays}

      {/* 状态指示灯 */}
      <mesh
        position={[width / 2 - 0.02, height / 2 - 0.015, depth / 2 + 0.005]}
      >
        <sphereGeometry args={[0.008, 8, 8]} />
        <meshStandardMaterial
          ref={statusMaterialRef}
          color={status.color}
          emissive={status.emissive}
          emissiveIntensity={0.3}
        />
      </mesh>

      {selected && (
        <lineSegments>
          <edgesGeometry
            args={[
              new THREE.BoxGeometry(width + 0.01, height + 0.01, depth + 0.01),
            ]}
          />
          <lineBasicMaterial color="#4096ff" linewidth={2} />
        </lineSegments>
      )}

      {/* 端口渲染 */}
      {ports.length > 0 && template && (
        <FrontPortPanel
          template={template}
          ports={ports}
          width={width}
          height={height}
          depth={depth}
        />
      )}

      {/* 后面板渲染 */}
      {showRear && (
        <RearPortPanel
          template={template}
          ports={ports}
          width={width}
          height={height}
          depth={depth}
        />
      )}

      {showTooltip && hovered && (
        <DeviceTooltip device={device} template={template} visible={true} />
      )}
    </group>
  );
};
