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

export const LoadBalancerModel: React.FC<DeviceModelProps> = ({
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
  const arrowMaterialLeftRef = useRef<THREE.MeshStandardMaterial | null>(null);
  const arrowMaterialRightRef = useRef<THREE.MeshStandardMaterial | null>(null);
  const arrowLeftIdRef = useRef<string | null>(null);
  const arrowRightIdRef = useRef<string | null>(null);
  const statusIdRef = useRef<string | null>(null);
  const arrowParamsRef = useRef<SinePulseParams>({
    enabled: true,
    base: 0.3,
    amp: 0.2,
    speed: 2,
  });
  const statusParamsRef = useRef<SinePulseParams>({
    enabled: true,
    base: 0.5,
    amp: 0.5,
    speed: 2,
  });
  const registry = useAnimationRegistry();
  const status =
    deviceStatusColors[device.status] || deviceStatusColors.offline;
  const isWarning = device.status === 'warning' || device.status === 'error';

  useEffect(() => {
    const left = arrowMaterialLeftRef.current;
    const right = arrowMaterialRightRef.current;
    if (left && !arrowLeftIdRef.current) {
      arrowLeftIdRef.current = registry.register(left, arrowParamsRef);
    }
    if (right && !arrowRightIdRef.current) {
      arrowRightIdRef.current = registry.register(right, arrowParamsRef);
    }
    return () => {
      if (arrowLeftIdRef.current) registry.unregister(arrowLeftIdRef.current);
      if (arrowRightIdRef.current) registry.unregister(arrowRightIdRef.current);
      arrowLeftIdRef.current = null;
      arrowRightIdRef.current = null;
    };
  }, [registry]);

  useEffect(() => {
    const mat = statusMaterialRef.current;
    if (!mat) return;
    if (isWarning) {
      if (!statusIdRef.current) {
        statusIdRef.current = registry.register(mat, statusParamsRef);
      }
      return;
    }
    if (statusIdRef.current) {
      registry.unregister(statusIdRef.current);
      statusIdRef.current = null;
    }
    mat.emissiveIntensity = 0.3;
  }, [isWarning, registry]);

  useEffect(() => {
    return () => {
      if (statusIdRef.current) registry.unregister(statusIdRef.current);
      statusIdRef.current = null;
    };
  }, [registry]);

  return (
    <group ref={groupRef} position={position}>
      {/* 负载均衡器主体 */}
      <mesh
        onClick={onClick}
        onDoubleClick={onDoubleClick}
        onPointerOver={onPointerOver}
        onPointerOut={onPointerOut}
      >
        <boxGeometry args={[width, height, depth]} />
        <meshStandardMaterial
          color={hovered ? '#20b2aa' : '#008b8b'}
          metalness={0.4}
          roughness={0.5}
        />
      </mesh>

      {/* 流量箭头指示(动态发光) */}
      <mesh position={[-width * 0.15, 0, depth / 2 + 0.003]}>
        <boxGeometry args={[0.02, height * 0.4, 0.003]} />
        <meshStandardMaterial
          ref={arrowMaterialLeftRef}
          color="#00ffff"
          emissive="#00ffff"
          emissiveIntensity={0.3}
        />
      </mesh>
      <mesh position={[width * 0.15, 0, depth / 2 + 0.003]}>
        <boxGeometry args={[0.02, height * 0.4, 0.003]} />
        <meshStandardMaterial
          ref={arrowMaterialRightRef}
          color="#00ffff"
          emissive="#00ffff"
          emissiveIntensity={0.3}
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
