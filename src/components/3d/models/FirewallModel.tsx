import React, { useEffect, useRef } from 'react';
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

export const FirewallModel: React.FC<DeviceModelProps> = ({
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

  return (
    <group ref={groupRef} position={position}>
      {/* 防火墙主体 */}
      <mesh
        onClick={onClick}
        onDoubleClick={onDoubleClick}
        onPointerOver={onPointerOver}
        onPointerOut={onPointerOut}
      >
        <boxGeometry args={[width, height, depth]} />
        <meshStandardMaterial
          color={hovered ? '#cd5c5c' : '#8b0000'}
          metalness={0.4}
          roughness={0.5}
        />
      </mesh>

      {/* 盾牌标识 */}
      <mesh position={[0, 0, depth / 2 + 0.003]}>
        <boxGeometry args={[width * 0.3, height * 0.6, 0.004]} />
        <meshStandardMaterial
          color="#ffd700"
          emissive="#ffd700"
          emissiveIntensity={0.2}
          metalness={0.6}
          roughness={0.3}
        />
      </mesh>

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
