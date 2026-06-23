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

export const SwitchModel: React.FC<DeviceModelProps> = ({
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

  // 使用真实端口数据或回退到模拟端口
  const portMatrix = useMemo(() => {
    // 如果有真实端口数据,使用 PortRenderer
    if (ports.length > 0 && template) {
      return null; // 将由 FrontPortPanel 渲染
    }

    // 回退:模拟端口矩阵
    const portsElements: React.ReactNode[] = [];
    const cols = Math.min(24, Math.floor(width / 0.02));
    const rows = 2;
    const startX = -width / 2 + 0.03;
    const startY = -height / 4;

    for (let row = 0; row < rows; row++) {
      for (let col = 0; col < cols; col++) {
        const isActive = Math.random() > 0.4;
        portsElements.push(
          <mesh
            key={`${row}-${col}`}
            position={[
              startX + col * 0.018,
              startY + row * 0.015,
              depth / 2 + 0.003,
            ]}
          >
            <boxGeometry args={[0.012, 0.01, 0.002]} />
            <meshStandardMaterial
              color={isActive ? '#1890ff' : '#333'}
              emissive={isActive ? '#0066cc' : '#000'}
              emissiveIntensity={isActive ? 0.6 : 0}
            />
          </mesh>,
        );
      }
    }
    return portsElements;
  }, [width, height, depth, ports.length, template]);

  return (
    <group ref={groupRef} position={position}>
      {/* 交换机主体 */}
      <mesh
        onClick={onClick}
        onDoubleClick={onDoubleClick}
        onPointerOver={onPointerOver}
        onPointerOut={onPointerOut}
      >
        <boxGeometry args={[width, height, depth]} />
        <meshStandardMaterial
          color={hovered ? '#4a7c9b' : '#2d5a7b'}
          metalness={0.4}
          roughness={0.5}
        />
      </mesh>

      {/* 前面板 */}
      <mesh position={[0, 0, depth / 2 + 0.001]}>
        <boxGeometry args={[width - 0.01, height - 0.005, 0.003]} />
        <meshStandardMaterial color="#1a2530" metalness={0.3} roughness={0.6} />
      </mesh>

      {/* 端口渲染 - 使用真实数据或模拟 */}
      {ports.length > 0 && template ? (
        <FrontPortPanel
          template={template}
          ports={ports}
          width={width}
          height={height}
          depth={depth}
        />
      ) : (
        portMatrix
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

      {/* 选中高亮 */}
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

      {showTooltip && hovered && (
        <DeviceTooltip device={device} template={template} visible={true} />
      )}
    </group>
  );
};
