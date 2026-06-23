import { useFrame } from '@react-three/fiber';
import React, {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useRef,
} from 'react';
import type * as THREE from 'three';

export type SinePulseParams = {
  enabled: boolean;
  base: number;
  amp: number;
  speed: number;
};

type Entry = {
  material: THREE.MeshStandardMaterial;
  paramsRef: React.MutableRefObject<SinePulseParams>;
};

type Registry = {
  register: (
    material: THREE.MeshStandardMaterial,
    paramsRef: React.MutableRefObject<SinePulseParams>,
  ) => string;
  unregister: (id: string) => void;
};

const AnimationRegistryContext = createContext<Registry | null>(null);

export function AnimationRegistryProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  const entriesRef = useRef(new Map<string, Entry>());

  const register = useCallback<Registry['register']>((material, paramsRef) => {
    const id = `${Date.now()}_${Math.random().toString(36).slice(2)}`;
    entriesRef.current.set(id, { material, paramsRef });
    return id;
  }, []);

  const unregister = useCallback<Registry['unregister']>((id) => {
    entriesRef.current.delete(id);
  }, []);

  const registry = useMemo<Registry>(
    () => ({ register, unregister }),
    [register, unregister],
  );

  useFrame(({ clock }) => {
    const t = clock.getElapsedTime();
    for (const entry of entriesRef.current.values()) {
      const p = entry.paramsRef.current;
      entry.material.emissiveIntensity = p.enabled
        ? p.base + Math.sin(t * p.speed) * p.amp
        : p.base;
    }
  });

  return (
    <AnimationRegistryContext.Provider value={registry}>
      {children}
    </AnimationRegistryContext.Provider>
  );
}

export function useAnimationRegistry() {
  const ctx = useContext(AnimationRegistryContext);
  return (
    ctx || {
      register: (material, paramsRef) => {
        material.emissiveIntensity = paramsRef.current.base;
        return `${Date.now()}_${Math.random().toString(36).slice(2)}`;
      },
      unregister: () => {},
    }
  );
}
