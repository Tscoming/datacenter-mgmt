import { useFrame } from '@react-three/fiber';
import React, { useEffect, useRef } from 'react';
import * as THREE from 'three';
import { FrontPortPanel, RearPortPanel } from '../PortRenderer3D';
import { DeviceTooltip } from './shared/DeviceTooltip';
import {
  type DeviceModelProps,
  deviceStatusColors,
} from './shared/deviceUtils';

export const RouterModel: React.FC<DeviceModelProps> = ({
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
  const phaseRef = useRef(0);
  const statusMaterialRef = useRef<THREE.MeshStandardMaterial | null>(null);
  const status =
    deviceStatusColors[device.status] || deviceStatusColors.offline;
  const isWarning = device.status === 'warning' || device.status === 'error';

  useFrame((_, delta) => {
    const mat = statusMaterialRef.current;
    if (!mat) return;
    if (!isWarning) return;
    phaseRef.current = (phaseRef.current + delta * 3) % (Math.PI * 2);
    mat.emissiveIntensity = 0.5 + Math.sin(phaseRef.current) * 0.5;
  });

  useEffect(() => {
    const mat = statusMaterialRef.current;
    if (!mat) return;
    if (!isWarning) mat.emissiveIntensity = 0.3;
  }, [isWarning]);

  return (
    <group ref={groupRef} position={position}>
      {/* 路由器主体 */}
      <mesh
        onClick={onClick}
        onDoubleClick={onDoubleClick}
        onPointerOver={onPointerOver}
        onPointerOut={onPointerOut}
      >
        <boxGeometry args={[width, height, depth]} />
        <meshStandardMaterial
          color={hovered ? '#6b8e7d' : '#4a6b5c'}
          metalness={0.4}
          roughness={0.5}
        />
      </mesh>

      {/* 前面板 */}
      <mesh position={[0, 0, depth / 2 + 0.001]}>
        <boxGeometry args={[width - 0.01, height - 0.005, 0.003]} />
        <meshStandardMaterial color="#1f2d25" metalness={0.3} roughness={0.6} />
      </mesh>

      {/* 网络接口指示灯 */}
      {[...Array(4)].map((_, i) => (
        <mesh key={i} position={[-width / 4 + i * 0.06, 0, depth / 2 + 0.005]}>
          <boxGeometry args={[0.03, 0.015, 0.002]} />
          <meshStandardMaterial
            color={Math.random() > 0.3 ? '#52c41a' : '#333'}
            emissive={Math.random() > 0.3 ? '#52c41a' : '#000'}
            emissiveIntensity={0.5}
          />
        </mesh>
      ))}

      {/* 状态指示灯 */}
      <mesh position={[width / 2 - 0.02, height / 3, depth / 2 + 0.005]}>
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
