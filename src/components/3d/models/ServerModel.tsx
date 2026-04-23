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

export const ServerModel: React.FC<DeviceModelProps> = ({
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

  // 硬盘LED阵列
  const diskLeds = useMemo(() => {
    const leds: React.ReactNode[] = [];
    const ledCount = Math.min(8, Math.floor(width / 0.05));
    const startX = -width / 2 + 0.03;

    for (let i = 0; i < ledCount; i++) {
      const isActive = Math.random() > 0.3;
      leds.push(
        <mesh
          key={i}
          position={[startX + i * 0.05, -height / 4, depth / 2 + 0.005]}
        >
          <boxGeometry args={[0.02, 0.01, 0.002]} />
          <meshStandardMaterial
            color={isActive ? '#00ff00' : '#333'}
            emissive={isActive ? '#00ff00' : '#000'}
            emissiveIntensity={isActive ? 0.8 : 0}
          />
        </mesh>,
      );
    }
    return leds;
  }, [width, height, depth]);

  return (
    <group ref={groupRef} position={position}>
      {/* 服务器主体 */}
      <mesh
        onClick={onClick}
        onDoubleClick={onDoubleClick}
        onPointerOver={onPointerOver}
        onPointerOut={onPointerOut}
      >
        <boxGeometry args={[width, height, depth]} />
        <meshStandardMaterial
          color={hovered ? '#7a8fa3' : '#5c6b7a'}
          metalness={0.5}
          roughness={0.4}
        />
      </mesh>

      {/* 前面板(深色) */}
      <mesh position={[0, 0, depth / 2 + 0.001]}>
        <boxGeometry args={[width - 0.01, height - 0.005, 0.003]} />
        <meshStandardMaterial color="#2a2f35" metalness={0.3} roughness={0.6} />
      </mesh>

      {/* 硬盘LED阵列 */}
      {diskLeds}

      {/* 端口渲染 - 如果有端口数据 */}
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

      {/* 电源指示灯 */}
      <mesh position={[width / 2 - 0.02, height / 3, depth / 2 + 0.005]}>
        <sphereGeometry args={[0.008, 8, 8]} />
        <meshStandardMaterial
          ref={statusMaterialRef}
          color={status.color}
          emissive={status.emissive}
          emissiveIntensity={0.3}
        />
      </mesh>

      {/* 选中高亮边框 */}
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

      {/* Tooltip */}
      {showTooltip && hovered && (
        <DeviceTooltip device={device} template={template} visible={true} />
      )}
    </group>
  );
};
