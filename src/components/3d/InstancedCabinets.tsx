import type { ThreeEvent } from '@react-three/fiber';
import React, { useCallback, useEffect, useMemo, useRef } from 'react';
import * as THREE from 'three';

type CabinetInstance = {
  id: string;
  position: [number, number, number];
  rotationY: number;
  width: number;
  height: number;
  depth: number;
  status: string;
};

export function InstancedCabinets({
  instances,
  selectedId,
  highlightedId,
  onClickCabinet,
  onDoubleClickCabinet,
}: {
  instances: CabinetInstance[];
  selectedId?: string | null;
  highlightedId?: string | null;
  onClickCabinet?: (id: string) => void;
  onDoubleClickCabinet?: (
    id: string,
    position: [number, number, number],
  ) => void;
}) {
  const meshRef = useRef<THREE.InstancedMesh>(null);
  const statusMeshRef = useRef<THREE.InstancedMesh>(null);
  const hoveredIndexRef = useRef<number | null>(null);

  const geometry = useMemo(() => new THREE.BoxGeometry(1, 1, 1), []);
  const statusGeometry = useMemo(
    () => new THREE.SphereGeometry(0.02, 10, 10),
    [],
  );
  const material = useMemo(
    () =>
      new THREE.MeshStandardMaterial({
        metalness: 0.3,
        roughness: 0.6,
        transparent: true,
        opacity: 0.95,
        vertexColors: true,
      }),
    [],
  );
  const statusMaterial = useMemo(
    () =>
      new THREE.MeshStandardMaterial({
        vertexColors: true,
        emissive: new THREE.Color('#ffffff'),
        emissiveIntensity: 0.8,
      }),
    [],
  );

  const statusColors = useMemo(
    () => ({
      normal: new THREE.Color('#5b6c7d'),
      warning: new THREE.Color('#faad14'),
      error: new THREE.Color('#f5222d'),
      offline: new THREE.Color('#8c8c8c'),
    }),
    [],
  );

  const baseColor = useMemo(() => new THREE.Color('#5b6c7d'), []);
  const highlightColor = useMemo(() => new THREE.Color('#4096ff'), []);
  const hoverColor = useMemo(() => new THREE.Color('#69b1ff'), []);
  const selectedOutlineColor = useMemo(() => new THREE.Color('#4096ff'), []);
  const highlightedOutlineColor = useMemo(() => new THREE.Color('#95de64'), []);

  useEffect(() => {
    return () => {
      geometry.dispose();
      statusGeometry.dispose();
      material.dispose();
      statusMaterial.dispose();
    };
  }, [geometry, material, statusGeometry, statusMaterial]);

  useEffect(() => {
    if (!meshRef.current || !statusMeshRef.current) return;
    const tempMatrix = new THREE.Matrix4();
    const q = new THREE.Quaternion();
    const euler = new THREE.Euler();
    const tempColor = new THREE.Color();
    const statusPos = new THREE.Vector3();
    const oneScale = new THREE.Vector3(1, 1, 1);
    const normalStatusColor = new THREE.Color('#52c41a');
    const statusColor = new THREE.Color();

    for (let i = 0; i < instances.length; i++) {
      const inst = instances[i];
      euler.set(0, inst.rotationY, 0);
      q.setFromEuler(euler);
      tempMatrix.compose(
        new THREE.Vector3(...inst.position),
        q,
        new THREE.Vector3(inst.width, inst.height, inst.depth),
      );
      meshRef.current.setMatrixAt(i, tempMatrix);

      statusPos.set(
        inst.position[0] + inst.width / 2 - 0.05,
        inst.position[1] + inst.height / 2 + 0.02,
        inst.position[2] + inst.depth / 2,
      );
      tempMatrix.compose(statusPos, q, oneScale);
      statusMeshRef.current.setMatrixAt(i, tempMatrix);

      const isSelected = inst.id === selectedId;
      const isHighlighted = inst.id === highlightedId;
      if (isSelected) tempColor.copy(selectedOutlineColor);
      else if (isHighlighted) tempColor.copy(highlightedOutlineColor);
      else
        tempColor.copy(
          statusColors[inst.status as keyof typeof statusColors] || baseColor,
        );
      meshRef.current.setColorAt(i, tempColor);

      if (inst.status === 'warning' || inst.status === 'error') {
        statusColor.copy(
          statusColors[inst.status as keyof typeof statusColors],
        );
      } else {
        statusColor.copy(normalStatusColor);
      }
      statusMeshRef.current.setColorAt(i, statusColor);
    }

    meshRef.current.instanceMatrix.needsUpdate = true;
    statusMeshRef.current.instanceMatrix.needsUpdate = true;
    if (meshRef.current.instanceColor) {
      meshRef.current.instanceColor.needsUpdate = true;
    }
    if (statusMeshRef.current.instanceColor) {
      statusMeshRef.current.instanceColor.needsUpdate = true;
    }
  }, [
    baseColor,
    highlightedId,
    highlightedOutlineColor,
    instances,
    selectedId,
    selectedOutlineColor,
    statusColors,
  ]);

  const setColorAt = useCallback((i: number, color: THREE.Color) => {
    if (!meshRef.current) return;
    meshRef.current.setColorAt(i, color);
    if (meshRef.current.instanceColor)
      meshRef.current.instanceColor.needsUpdate = true;
  }, []);

  const handlePointerMove = useCallback(
    (e: ThreeEvent<PointerEvent>) => {
      e.stopPropagation();
      if (e.instanceId === undefined) return;
      const prev = hoveredIndexRef.current;
      const next = e.instanceId;
      if (prev === next) return;

      if (prev !== null && instances[prev]) {
        const inst = instances[prev];
        const isSelected = inst.id === selectedId;
        const isHighlighted = inst.id === highlightedId;
        if (isSelected) setColorAt(prev, selectedOutlineColor);
        else if (isHighlighted) setColorAt(prev, highlightedOutlineColor);
        else
          setColorAt(
            prev,
            statusColors[inst.status as keyof typeof statusColors] || baseColor,
          );
      }

      if (instances[next]) setColorAt(next, hoverColor);
      hoveredIndexRef.current = next;
    },
    [
      baseColor,
      highlightedId,
      highlightedOutlineColor,
      hoverColor,
      instances,
      selectedId,
      selectedOutlineColor,
      setColorAt,
      statusColors,
    ],
  );

  const handlePointerOut = useCallback(() => {
    const prev = hoveredIndexRef.current;
    hoveredIndexRef.current = null;
    if (prev === null || !instances[prev]) return;
    const inst = instances[prev];
    const isSelected = inst.id === selectedId;
    const isHighlighted = inst.id === highlightedId;
    if (isSelected) setColorAt(prev, selectedOutlineColor);
    else if (isHighlighted) setColorAt(prev, highlightedOutlineColor);
    else
      setColorAt(
        prev,
        statusColors[inst.status as keyof typeof statusColors] || baseColor,
      );
  }, [
    baseColor,
    highlightedId,
    highlightedOutlineColor,
    instances,
    selectedId,
    selectedOutlineColor,
    setColorAt,
    statusColors,
  ]);

  const handleClick = useCallback(
    (e: ThreeEvent<MouseEvent>) => {
      e.stopPropagation();
      if (e.instanceId === undefined) return;
      const inst = instances[e.instanceId];
      if (!inst) return;
      onClickCabinet?.(inst.id);
    },
    [instances, onClickCabinet],
  );

  const handleDoubleClick = useCallback(
    (e: ThreeEvent<MouseEvent>) => {
      e.stopPropagation();
      if (e.instanceId === undefined) return;
      const inst = instances[e.instanceId];
      if (!inst) return;
      onDoubleClickCabinet?.(inst.id, inst.position);
    },
    [instances, onDoubleClickCabinet],
  );

  if (instances.length === 0) return null;

  return (
    <group>
      <instancedMesh
        ref={meshRef}
        args={[geometry, material, instances.length]}
        onPointerMove={handlePointerMove}
        onPointerOut={handlePointerOut}
        onClick={handleClick}
        onDoubleClick={handleDoubleClick}
      />
      <instancedMesh
        ref={statusMeshRef}
        args={[statusGeometry, statusMaterial, instances.length]}
      />
    </group>
  );
}
