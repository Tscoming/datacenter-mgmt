import type { ActionType, ProColumns } from '@ant-design/pro-components';
import {
  ModalForm,
  PageContainer,
  ProFormDatePicker,
  ProFormSelect,
  ProFormText,
  ProFormTextArea,
  ProTable,
} from '@ant-design/pro-components';
import { useAccess } from '@umijs/max';
import {
  Alert,
  Badge,
  Button,
  Descriptions,
  Drawer,
  Form,
  Input,
  InputNumber,
  Modal,
  message,
  Popconfirm,
  Select,
  Space,
  Tabs,
  Tag,
  Tooltip,
  Typography,
} from 'antd';
import {
  AlertTriangle,
  Cable,
  CheckCircle,
  Edit3,
  Eye,
  Network,
  PlugZap,
  Plus,
  Server,
  Settings,
  ShieldCheck,
  Trash2,
  Wifi,
  WifiOff,
} from 'lucide-react';
import { useEffect, useMemo, useRef, useState } from 'react';
import DevicePortView from '@/components/DevicePortView';
import { getCabinets, getCabinetUUsage } from '@/services/idc/cabinet';
import {
  createDevice,
  type DeviceSshBinding,
  type DeviceSshTestResult,
  deleteDevice,
  getDeviceSshBinding,
  getDevices,
  testDeviceSsh,
  unmountDevice,
  updateDevice,
  updateDeviceSshBinding,
  validateDeviceMount,
} from '@/services/idc/device';
import { getAllDeviceTemplates } from '@/services/idc/deviceTemplate';
import {
  getManagedKeys,
  type ManagedKey,
  verifyKeyManagement,
} from '@/services/system/keyManagement';

const statusConfig: Record<
  string,
  { color: string; text: string; icon: React.ReactNode }
> = {
  online: { color: 'success', text: '在线', icon: <Wifi size={14} /> },
  offline: { color: 'default', text: '离线', icon: <WifiOff size={14} /> },
  warning: {
    color: 'warning',
    text: '告警',
    icon: <AlertTriangle size={14} />,
  },
  error: { color: 'error', text: '故障', icon: <AlertTriangle size={14} /> },
  maintenance: {
    color: 'processing',
    text: '维护中',
    icon: <Settings size={14} />,
  },
};

const sshStageText: Record<DeviceSshTestResult['stage'], string> = {
  network: '网络连接',
  handshake: 'SSH 握手',
  authentication: '密钥认证',
  ready: '连接就绪',
};

// U位可视化选择组件
const USlotSelector: React.FC<{
  cabinetId: string;
  uHeight: number; // 机柜总U位
  deviceUHeight: number; // 设备占用U位
  selectedStartU: number | undefined;
  onSelect: (startU: number) => void;
  uUsage?: { u: number; occupied: boolean; deviceName?: string }[];
  loading?: boolean;
}> = ({
  cabinetId,
  uHeight,
  deviceUHeight,
  selectedStartU,
  onSelect,
  uUsage,
  loading,
}) => {
  const [innerUsage, setInnerUsage] = useState<
    { u: number; occupied: boolean; deviceName?: string }[]
  >([]);
  const [innerLoading, setInnerLoading] = useState(false);
  const mergedLoading = typeof loading === 'boolean' ? loading : innerLoading;
  const mergedUsage = uUsage ?? innerUsage;

  useEffect(() => {
    if (cabinetId) {
      if (uUsage) return;
      setInnerLoading(true);
      getCabinetUUsage(cabinetId)
        .then((res) => {
          if (res.success && res.data) {
            // API返回的是对象 { uSlots: [...] }，需要提取并转换
            const slots = res.data.uSlots || [];
            setInnerUsage(
              slots.map((s: any) => ({
                u: s.u,
                occupied: !!s.deviceId,
                deviceName: s.deviceName,
              })),
            );
          }
        })
        .finally(() => setInnerLoading(false));
    }
  }, [cabinetId, uUsage]);

  // 检查某个起始U位是否可用
  const isSlotAvailable = (startU: number) => {
    for (let u = startU; u < startU + deviceUHeight; u++) {
      const slot = mergedUsage.find((s) => s.u === u);
      if (slot?.occupied) return false;
      if (u > uHeight) return false;
    }
    return true;
  };

  // 生成可用的起始U位选项
  const availableSlots = useMemo(() => {
    const slots: number[] = [];
    for (let u = 1; u <= uHeight - deviceUHeight + 1; u++) {
      if (isSlotAvailable(u)) {
        slots.push(u);
      }
    }
    return slots;
  }, [mergedUsage, uHeight, deviceUHeight]);

  if (!cabinetId)
    return <Alert message="请先选择目标机柜" type="info" showIcon />;
  if (mergedLoading) return <div>加载U位信息...</div>;

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
      <div style={{ fontSize: 12, color: '#8c8c8c' }}>
        可用U位: {availableSlots.length} 个 | 设备需占用: {deviceUHeight}U
      </div>
      <div
        style={{
          display: 'flex',
          gap: 4,
          flexWrap: 'wrap',
          maxHeight: 200,
          overflowY: 'auto',
        }}
      >
        {Array.from({ length: uHeight }, (_, i) => uHeight - i).map((u) => {
          const slot = mergedUsage.find((s) => s.u === u);
          const isOccupied = slot?.occupied;
          const isSelected =
            selectedStartU &&
            u >= selectedStartU &&
            u < selectedStartU + deviceUHeight;
          const canStart = !isOccupied && isSlotAvailable(u);

          return (
            <Tooltip
              key={u}
              title={
                isOccupied
                  ? `已被 ${slot.deviceName} 占用`
                  : canStart
                    ? `点击选择 U${u} 作为起始位置`
                    : '不可用'
              }
            >
              <div
                onClick={() => canStart && onSelect(u)}
                style={{
                  width: 32,
                  height: 20,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: 11,
                  fontFamily: 'monospace',
                  borderRadius: 3,
                  cursor: canStart ? 'pointer' : 'not-allowed',
                  backgroundColor: isSelected
                    ? '#1890ff'
                    : isOccupied
                      ? '#ffccc7'
                      : '#f0f0f0',
                  color: isSelected ? '#fff' : isOccupied ? '#f5222d' : '#333',
                  border: isSelected
                    ? '2px solid #1890ff'
                    : '1px solid #d9d9d9',
                  transition: 'all 0.2s',
                }}
              >
                {u}
              </div>
            </Tooltip>
          );
        })}
      </div>
      {selectedStartU && (
        <Alert
          type="success"
          message={`已选择: U${selectedStartU} - U${selectedStartU + deviceUHeight - 1}`}
          icon={<CheckCircle size={14} />}
          showIcon
        />
      )}
      {availableSlots.length === 0 && (
        <Alert type="error" message="该机柜没有足够的连续空闲U位" showIcon />
      )}
    </div>
  );
};

const DevicePage: React.FC = () => {
  const access = useAccess();
  const actionRef = useRef<ActionType>(null);
  const [createModalOpen, setCreateModalOpen] = useState(false);
  const [editModalOpen, setEditModalOpen] = useState(false);
  const [detailDrawerOpen, setDetailDrawerOpen] = useState(false);
  const [currentRow, setCurrentRow] = useState<IDC.Device>();
  const [keyword, setKeyword] = useState('');
  const [templates, setTemplates] = useState<any[]>([]);
  const [cabinets, setCabinets] = useState<any[]>([]);

  // 上架表单状态
  const [selectedTemplateId, setSelectedTemplateId] = useState<string>();
  const [selectedCabinetId, setSelectedCabinetId] = useState<string>();
  const [selectedStartU, setSelectedStartU] = useState<number>();
  const [cabinetSlots, setCabinetSlots] = useState<
    { u: number; occupied: boolean; deviceName?: string }[]
  >([]);
  const [cabinetSlotsLoading, setCabinetSlotsLoading] = useState(false);
  const [mountValidation, setMountValidation] =
    useState<IDC.DeviceMountValidationResult | null>(null);
  const [mountValidationLoading, setMountValidationLoading] = useState(false);
  const [editSelectedCabinetId, setEditSelectedCabinetId] = useState<string>();
  const [editSelectedStartU, setEditSelectedStartU] = useState<number>();
  const [editCabinetSlots, setEditCabinetSlots] = useState<
    { u: number; occupied: boolean; deviceName?: string }[]
  >([]);
  const [editCabinetSlotsLoading, setEditCabinetSlotsLoading] = useState(false);
  const [sshVerificationOpen, setSshVerificationOpen] = useState(false);
  const [sshVerificationLoading, setSshVerificationLoading] = useState(false);
  const [sshVerificationPassword, setSshVerificationPassword] = useState('');
  const [sshVerificationToken, setSshVerificationToken] = useState('');
  const [sshKeys, setSshKeys] = useState<ManagedKey[]>([]);
  const [sshBinding, setSshBinding] = useState<DeviceSshBinding | null>(null);
  const [sshKeyId, setSshKeyId] = useState<string>();
  const [sshUsername, setSshUsername] = useState('root');
  const [sshPort, setSshPort] = useState(22);
  const [sshPassphrase, setSshPassphrase] = useState('');
  const [sshTestLoading, setSshTestLoading] = useState(false);
  const [sshTestResult, setSshTestResult] =
    useState<DeviceSshTestResult | null>(null);
  const [editActiveTab, setEditActiveTab] = useState('basic');

  // 端口详情视图状态
  const [portViewOpen, setPortViewOpen] = useState(false);
  const [portViewDevice, setPortViewDevice] = useState<IDC.Device | null>(null);

  useEffect(() => {
    getAllDeviceTemplates().then((res) => {
      if (res.success) setTemplates(res.data || []);
    });
    getCabinets({ pageSize: 1000 }).then((res) => {
      if (res.success) setCabinets(res.data || []);
    });
  }, []);

  const selectedTemplate = useMemo(() => {
    return templates.find((t) => t.id === selectedTemplateId);
  }, [selectedTemplateId, templates]);

  const selectedCabinet = useMemo(() => {
    return cabinets.find((c) => c.id === selectedCabinetId);
  }, [selectedCabinetId, cabinets]);

  const editSelectedCabinet = useMemo(() => {
    return cabinets.find((c) => c.id === editSelectedCabinetId);
  }, [editSelectedCabinetId, cabinets]);

  const editSelectedTemplate = useMemo(() => {
    return templates.find((t) => t.id === currentRow?.templateId);
  }, [currentRow?.templateId, templates]);

  const editDeviceUHeight = useMemo(() => {
    if (editSelectedTemplate?.uHeight) return editSelectedTemplate.uHeight;
    if (currentRow?.startU && currentRow?.endU) {
      return currentRow.endU - currentRow.startU + 1;
    }
    return 1;
  }, [currentRow, editSelectedTemplate]);

  useEffect(() => {
    if (!selectedCabinetId) {
      setCabinetSlots([]);
      setMountValidation(null);
      return;
    }
    setCabinetSlotsLoading(true);
    getCabinetUUsage(selectedCabinetId)
      .then((res) => {
        if (res.success && res.data) {
          const slots = res.data.uSlots || [];
          setCabinetSlots(
            slots.map((s: any) => ({
              u: s.u,
              occupied: !!s.deviceId,
              deviceName: s.deviceName,
            })),
          );
        } else {
          setCabinetSlots([]);
        }
      })
      .finally(() => setCabinetSlotsLoading(false));
  }, [selectedCabinetId]);

  useEffect(() => {
    if (!editSelectedCabinetId || !currentRow) {
      setEditCabinetSlots([]);
      return;
    }
    setEditCabinetSlotsLoading(true);
    getCabinetUUsage(editSelectedCabinetId)
      .then((res) => {
        if (res.success && res.data) {
          const slots = res.data.uSlots || [];
          setEditCabinetSlots(
            slots.map((s: any) => ({
              u: s.u,
              occupied: !!s.deviceId && s.deviceId !== currentRow.id,
              deviceName: s.deviceName,
            })),
          );
        } else {
          setEditCabinetSlots([]);
        }
      })
      .finally(() => setEditCabinetSlotsLoading(false));
  }, [editSelectedCabinetId, currentRow]);

  const deviceMaxPower = useMemo(() => {
    if (selectedTemplate?.maxPower) return selectedTemplate.maxPower;
    const category = selectedTemplate?.category;
    const defaults: Record<string, number> = {
      server: 800,
      storage: 1200,
      switch: 300,
      router: 300,
      firewall: 400,
      loadbalancer: 400,
      other: 200,
    };
    return category ? defaults[category] || 200 : 200;
  }, [selectedTemplate]);

  const powerPortCount = useMemo(() => {
    return (
      selectedTemplate?.portGroups?.reduce((sum: number, pg: any) => {
        return pg.portType === 'Power' ? sum + (pg.count || 0) : sum;
      }, 0) || 0
    );
  }, [selectedTemplate]);

  const totalPortCount = useMemo(() => {
    return (
      selectedTemplate?.portGroups?.reduce((sum: number, pg: any) => {
        return sum + (pg.count || 0);
      }, 0) || 0
    );
  }, [selectedTemplate]);

  useEffect(() => {
    const cabinetId = selectedCabinetId;
    const templateId = selectedTemplateId;
    const cabinet = selectedCabinet;
    const tpl = selectedTemplate;

    if (!cabinetId || !templateId || !cabinet || !tpl) {
      setMountValidation(null);
      return;
    }

    const deviceUHeight = tpl.uHeight || 1;
    const startU = selectedStartU;
    const endU = startU ? startU + deviceUHeight - 1 : undefined;

    setMountValidationLoading(true);
    validateDeviceMount({
      cabinetId,
      cabinetUHeight: cabinet.uHeight,
      cabinetMaxPower: cabinet.maxPower,
      cabinetCurrentPower: cabinet.currentPower,
      templateId,
      deviceUHeight,
      deviceMaxPower,
      powerPortCount,
      totalPortCount,
      startU,
      endU,
    })
      .then((res) => {
        if (res.success && res.data) {
          setMountValidation(res.data);
        } else {
          setMountValidation(null);
        }
      })
      .finally(() => setMountValidationLoading(false));
  }, [
    selectedCabinetId,
    selectedTemplateId,
    selectedCabinet,
    selectedTemplate,
    selectedStartU,
    deviceMaxPower,
    powerPortCount,
    totalPortCount,
  ]);

  const cabinetOptions = useMemo(() => {
    const deviceUHeight = selectedTemplate?.uHeight || 1;
    const requiredPower = deviceMaxPower || 0;
    return [...cabinets]
      .map((c) => {
        const availableU = (c.uHeight || 42) - (c.usedU || 0);
        const headroom = (c.maxPower || 0) - (c.currentPower || 0);
        const canFitU = availableU >= deviceUHeight;
        const canFitPower = c.maxPower
          ? c.currentPower + requiredPower <= c.maxPower
          : true;
        return {
          value: c.id,
          sortScore:
            (canFitU ? 1_000_000 : 0) +
            Math.max(0, availableU) * 1000 +
            Math.max(0, headroom),
          label: `${c.name} (${c.code}) - 剩余${availableU}U | 余功率${Math.max(0, headroom)}W`,
        };
      })
      .sort((a, b) => b.sortScore - a.sortScore)
      .map(({ value, label }) => ({ value, label }));
  }, [cabinets, selectedTemplate, deviceMaxPower]);

  const validationSummary = useMemo(() => {
    if (!selectedTemplate || !selectedCabinet) return null;
    const deviceUHeight = selectedTemplate.uHeight || 1;
    const startU = selectedStartU;
    const endU = startU ? startU + deviceUHeight - 1 : undefined;
    const errors: string[] = [];
    const warnings: string[] = [];

    if (startU && endU) {
      if (endU > selectedCabinet.uHeight) {
        errors.push('U位超出机柜高度');
      } else {
        const occupied = cabinetSlots.some(
          (s) => s.occupied && s.u >= startU && s.u <= endU,
        );
        if (occupied) errors.push('所选U位区间存在占用冲突');
      }
    }

    const maxPower = selectedCabinet.maxPower || 0;
    const currentPower = selectedCabinet.currentPower || 0;
    const nextPower = maxPower ? currentPower + deviceMaxPower : currentPower;

    if (maxPower) {
      if (nextPower > maxPower) {
        errors.push('功率将超过机柜最大承载');
      } else if (nextPower / maxPower >= 0.8) {
        warnings.push('功率负载较高，可能存在散热压力');
      }
    }

    if (!totalPortCount) warnings.push('设备模板未定义端口信息');
    if (powerPortCount < 2) warnings.push('设备电源口可能不支持A/B双路冗余');
    warnings.push('A/B路电源来源未配置，建议在电力拓扑中补齐冗余链路');

    return { errors, warnings, startU, endU, nextPower, maxPower };
  }, [
    selectedTemplate,
    selectedCabinet,
    selectedStartU,
    cabinetSlots,
    deviceMaxPower,
    powerPortCount,
    totalPortCount,
  ]);

  const editValidationSummary = useMemo(() => {
    if (!editSelectedCabinet || !currentRow) return null;
    const startU = editSelectedStartU;
    const endU = startU ? startU + editDeviceUHeight - 1 : undefined;
    const errors: string[] = [];
    const warnings: string[] = [];

    if (startU && endU) {
      if (endU > editSelectedCabinet.uHeight) {
        errors.push('U位超出机柜高度');
      } else {
        const occupied = editCabinetSlots.some(
          (s) => s.occupied && s.u >= startU && s.u <= endU,
        );
        if (occupied) errors.push('所选U位区间存在占用冲突');
      }
    } else {
      errors.push('请选择起始U位');
    }

    const maxPower = editSelectedCabinet.maxPower || 0;
    const currentPower = editSelectedCabinet.currentPower || 0;
    if (maxPower && currentPower / maxPower >= 0.8) {
      warnings.push('目标机柜功率负载较高，建议确认供电和散热余量');
    }

    return { errors, warnings, startU, endU };
  }, [
    currentRow,
    editCabinetSlots,
    editDeviceUHeight,
    editSelectedCabinet,
    editSelectedStartU,
  ]);

  const resetCreateForm = () => {
    setSelectedTemplateId(undefined);
    setSelectedCabinetId(undefined);
    setSelectedStartU(undefined);
    setCabinetSlots([]);
    setMountValidation(null);
  };

  const resetEditForm = (record?: IDC.Device) => {
    setEditActiveTab('basic');
    setEditSelectedCabinetId(record?.cabinetId);
    setEditSelectedStartU(record?.startU);
    setEditCabinetSlots([]);
    setSshVerificationOpen(false);
    setSshVerificationPassword('');
    setSshVerificationToken('');
    setSshKeys([]);
    setSshBinding(null);
    setSshKeyId(undefined);
    setSshUsername('root');
    setSshPort(22);
    setSshPassphrase('');
    setSshTestResult(null);
  };

  const verifyAndLoadSshBinding = async () => {
    if (!currentRow || !sshVerificationPassword) {
      message.warning('请输入当前管理员账户密码');
      return;
    }
    setSshVerificationLoading(true);
    try {
      const verified = await verifyKeyManagement(sshVerificationPassword);
      const token = verified.data.verificationToken;
      const [keysResponse, bindingResponse] = await Promise.all([
        getManagedKeys(token),
        getDeviceSshBinding(currentRow.id, token),
      ]);
      setSshVerificationToken(token);
      setSshKeys(keysResponse.data || []);
      setSshBinding(bindingResponse.data || null);
      setSshTestResult(null);
      if (bindingResponse.data) {
        setSshKeyId(bindingResponse.data.keyId);
        setSshUsername(bindingResponse.data.username);
        setSshPort(bindingResponse.data.port);
      } else {
        setSshKeyId(undefined);
        setSshUsername('root');
        setSshPort(22);
      }
      setSshVerificationPassword('');
      setSshVerificationOpen(false);
    } finally {
      setSshVerificationLoading(false);
    }
  };

  const sshBindingUnchanged =
    !!sshBinding &&
    sshKeyId === sshBinding.keyId &&
    sshUsername.trim() === sshBinding.username &&
    sshPort === sshBinding.port;

  const runSshConnectionTest = async () => {
    if (!currentRow || !sshVerificationToken) return;
    if (!sshKeyId) {
      message.warning('请先选择密钥');
      return;
    }
    if (!sshUsername.trim()) {
      message.warning('请输入 SSH 用户名');
      return;
    }
    setSshTestLoading(true);
    setSshTestResult(null);
    try {
      const response = await testDeviceSsh(
        currentRow.id,
        {
          keyId: sshKeyId,
          username: sshUsername.trim(),
          port: sshPort,
          passphrase: sshPassphrase || undefined,
        },
        sshVerificationToken,
      );
      setSshTestResult(response.data || null);
    } finally {
      setSshTestLoading(false);
    }
  };

  const columns: ProColumns<IDC.Device>[] = [
    {
      title: '设备名称',
      dataIndex: 'name',
      ellipsis: true,
      render: (_, record) => (
        <Space>
          <Server size={16} style={{ color: '#1890ff' }} />
          <span style={{ fontWeight: 500 }}>{record.name}</span>
        </Space>
      ),
    },
    {
      title: '资产编码',
      dataIndex: 'assetCode',
      width: 150,
      copyable: true,
    },
    {
      title: '设备型号',
      dataIndex: 'templateId',
      width: 180,
      search: false,
      render: (_, record) => {
        const tpl = templates.find((t) => t.id === record.templateId);
        return tpl ? `${tpl.brand} ${tpl.model}` : record.templateId;
      },
    },
    {
      title: '所在机柜',
      dataIndex: 'cabinetId',
      width: 150,
      valueType: 'select',
      fieldProps: {
        options: cabinets.map((c) => ({ value: c.id, label: c.name })),
        showSearch: true,
      },
      render: (_, record) => {
        const cab = cabinets.find((c) => c.id === record.cabinetId);
        return cab?.name || record.cabinetId;
      },
    },
    {
      title: 'U位',
      dataIndex: 'startU',
      width: 80,
      search: false,
      render: (_, record) =>
        record.startU === record.endU
          ? `U${record.startU}`
          : `U${record.startU}-${record.endU}`,
    },
    {
      title: '管理IP',
      dataIndex: 'managementIp',
      width: 130,
      copyable: true,
      render: (_, record) =>
        record.managementIp && (
          <Tooltip title="点击复制">
            <Space>
              <Network size={14} style={{ color: '#8c8c8c' }} />
              {record.managementIp}
            </Space>
          </Tooltip>
        ),
    },
    {
      title: '状态',
      dataIndex: 'status',
      width: 100,
      valueType: 'select',
      valueEnum: {
        online: { text: '在线', status: 'Success' },
        offline: { text: '离线', status: 'Default' },
        warning: { text: '告警', status: 'Warning' },
        error: { text: '故障', status: 'Error' },
        maintenance: { text: '维护中', status: 'Processing' },
      },
      render: (_, record) => (
        <Tag
          icon={statusConfig[record.status]?.icon}
          color={statusConfig[record.status]?.color}
        >
          {statusConfig[record.status]?.text}
        </Tag>
      ),
    },
    {
      title: '负责人',
      dataIndex: 'owner',
      width: 80,
      search: false,
    },
    {
      title: '部门',
      dataIndex: 'department',
      width: 120,
      valueType: 'select',
      fieldProps: {
        options: [
          { value: '网络运维部', label: '网络运维部' },
          { value: '应用开发部', label: '应用开发部' },
          { value: '数据库运维部', label: '数据库运维部' },
          { value: '安全运维部', label: '安全运维部' },
          { value: '存储运维部', label: '存储运维部' },
          { value: 'AI研发部', label: 'AI研发部' },
        ],
      },
    },
    {
      title: '架设状态',
      dataIndex: 'isMounted',
      width: 90,
      valueType: 'select',
      valueEnum: {
        true: { text: '已上架', status: 'Success' },
        false: { text: '已下架', status: 'Default' },
      },
      render: (_, record) => (
        <Tag color={record.isMounted !== false ? 'green' : 'default'}>
          {record.isMounted !== false ? '已上架' : '已下架'}
        </Tag>
      ),
    },
    {
      title: '质保到期',
      dataIndex: 'warrantyExpiry',
      width: 110,
      valueType: 'date',
      search: false,
      render: (_, record) => {
        if (!record.warrantyExpiry) return '-';
        const expiry = new Date(record.warrantyExpiry);
        const now = new Date();
        const daysLeft = Math.ceil(
          (expiry.getTime() - now.getTime()) / (1000 * 60 * 60 * 24),
        );
        const isExpiringSoon = daysLeft > 0 && daysLeft <= 90;
        const isExpired = daysLeft <= 0;
        return (
          <Tooltip title={isExpired ? '已过期' : `剩余${daysLeft}天`}>
            <span
              style={{
                color: isExpired
                  ? '#f5222d'
                  : isExpiringSoon
                    ? '#faad14'
                    : undefined,
              }}
            >
              {record.warrantyExpiry}
            </span>
          </Tooltip>
        );
      },
    },
    {
      title: '操作',
      valueType: 'option',
      width: 180,
      fixed: 'right',
      render: (_, record) => [
        <Tooltip key="ports" title="查看端口使用情况">
          <Button
            type="link"
            size="small"
            icon={<Cable size={14} />}
            onClick={() => {
              setPortViewDevice(record);
              setPortViewOpen(true);
            }}
          >
            端口
          </Button>
        </Tooltip>,
        <Button
          key="view"
          type="link"
          size="small"
          icon={<Eye size={14} />}
          onClick={() => {
            setCurrentRow(record);
            setDetailDrawerOpen(true);
          }}
        >
          详情
        </Button>,
        <Button
          key="edit"
          type="link"
          size="small"
          icon={<Edit3 size={14} />}
          onClick={() => {
            setCurrentRow(record);
            resetEditForm(record);
            setEditModalOpen(true);
          }}
        >
          编辑
        </Button>,
        <Popconfirm
          key="unmount"
          title="确定要下架这个设备吗？"
          description="下架后设备的连接信息将被释放，历史记录会保留。"
          onConfirm={async () => {
            const res = await unmountDevice(record.id);
            if (res.success) {
              message.success('设备已下架');
              actionRef.current?.reload();
            }
          }}
          disabled={record.isMounted === false}
        >
          <Button
            type="link"
            size="small"
            danger
            icon={<Trash2 size={14} />}
            disabled={record.isMounted === false}
          >
            下架
          </Button>
        </Popconfirm>,
        <Popconfirm
          key="delete"
          title="确定要删除这个设备吗？"
          description="删除后数据将无法恢复。"
          onConfirm={async () => {
            const res = await deleteDevice(record.id);
            if (res.success) {
              message.success('设备已删除');
              actionRef.current?.reload();
            }
          }}
        >
          <Button type="link" size="small" danger icon={<Trash2 size={14} />}>
            删除
          </Button>
        </Popconfirm>,
      ],
    },
  ];

  return (
    <PageContainer
      header={{
        title: '设备管理',
        subTitle: '管理已上架的设备',
      }}
    >
      <ProTable<IDC.Device>
        headerTitle="设备列表"
        actionRef={actionRef}
        rowKey="id"
        columns={columns}
        search={false}
        params={{ keyword }}
        debounceTime={300}
        scroll={{ x: 1600 }}
        request={async (params) => {
          const res = await getDevices({
            current: params.current,
            pageSize: params.pageSize,
            keyword: params.keyword,
          });
          return {
            data: res.data || [],
            success: res.success,
            total: res.total || 0,
          };
        }}
        toolBarRender={() => [
          <Input
            key="global-search"
            allowClear
            placeholder="全局搜索"
            style={{ width: 280 }}
            value={keyword}
            onChange={(event) => setKeyword(event.target.value)}
          />,
          <Button
            key="create"
            type="primary"
            icon={<Plus size={16} />}
            onClick={() => {
              resetCreateForm();
              setCreateModalOpen(true);
            }}
          >
            设备上架
          </Button>,
        ]}
      />

      {/* 设备上架模态框 - 优化版 */}
      <ModalForm
        title="设备上架"
        open={createModalOpen}
        onOpenChange={(open) => {
          setCreateModalOpen(open);
          if (!open) resetCreateForm();
        }}
        width={800}
        onFinish={async (values) => {
          if (!selectedStartU) {
            message.error('请选择起始U位');
            return false;
          }
          if (mountValidationLoading) {
            message.warning('正在进行容量校验，请稍后');
            return false;
          }
          if (mountValidation && !mountValidation.ok) {
            message.error('容量校验未通过，请调整上架位置或目标机柜');
            return false;
          }
          const deviceUHeight = selectedTemplate?.uHeight || 1;
          const res = await createDevice({
            ...values,
            startU: selectedStartU,
            endU: selectedStartU + deviceUHeight - 1,
          } as unknown as IDC.DeviceCreateParams);
          if (res.success) {
            message.success('设备上架成功');
            actionRef.current?.reload();
            return true;
          }
          return false;
        }}
      >
        <div
          style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}
        >
          <div>
            <ProFormSelect
              name="templateId"
              label="设备型号"
              options={templates.map((t) => ({
                value: t.id,
                label: `${t.brand} ${t.model} (${t.uHeight}U)`,
              }))}
              showSearch
              rules={[{ required: true, message: '请选择设备型号' }]}
              fieldProps={{
                onChange: (value: string) => {
                  setSelectedTemplateId(value);
                  setSelectedStartU(undefined);
                },
              }}
            />
            <ProFormSelect
              name="cabinetId"
              label="目标机柜"
              options={cabinetOptions}
              showSearch
              rules={[{ required: true, message: '请选择目标机柜' }]}
              fieldProps={{
                onChange: (value: string) => {
                  setSelectedCabinetId(value);
                  setSelectedStartU(undefined);
                },
              }}
            />

            {/* U位可视化选择 */}
            {selectedCabinetId && selectedTemplateId && (
              <div style={{ marginBottom: 24 }}>
                <div style={{ marginBottom: 8, fontWeight: 500 }}>
                  选择起始U位 <span style={{ color: '#f5222d' }}>*</span>
                </div>
                <USlotSelector
                  cabinetId={selectedCabinetId}
                  uHeight={selectedCabinet?.uHeight || 42}
                  deviceUHeight={selectedTemplate?.uHeight || 1}
                  selectedStartU={selectedStartU}
                  onSelect={setSelectedStartU}
                  uUsage={cabinetSlots}
                  loading={cabinetSlotsLoading}
                />
              </div>
            )}

            {(selectedCabinetId || selectedTemplateId) && (
              <div style={{ marginBottom: 24 }}>
                <div style={{ marginBottom: 8, fontWeight: 500 }}>容量校验</div>
                {mountValidationLoading && <div>校验中...</div>}
                {!mountValidationLoading && (
                  <>
                    {validationSummary?.errors?.length ? (
                      <Alert
                        type="error"
                        showIcon
                        message="校验未通过"
                        description={
                          <div>
                            {validationSummary.errors.map((e) => (
                              <div key={e}>{e}</div>
                            ))}
                          </div>
                        }
                      />
                    ) : (
                      <Alert
                        type="success"
                        showIcon
                        message="基础容量校验通过"
                      />
                    )}
                    {validationSummary?.warnings?.length ? (
                      <Alert
                        style={{ marginTop: 8 }}
                        type="warning"
                        showIcon
                        message="建议关注项"
                        description={
                          <div>
                            {validationSummary.warnings.map((w) => (
                              <div key={w}>{w}</div>
                            ))}
                          </div>
                        }
                      />
                    ) : null}
                    {mountValidation?.recommendedStartU &&
                      mountValidation.recommendedEndU && (
                        <Alert
                          style={{ marginTop: 8 }}
                          type="info"
                          showIcon
                          message={`推荐上架位置：U${mountValidation.recommendedStartU}-U${mountValidation.recommendedEndU}`}
                          action={
                            <Button
                              size="small"
                              type="link"
                              onClick={() =>
                                setSelectedStartU(
                                  mountValidation.recommendedStartU,
                                )
                              }
                            >
                              使用推荐
                            </Button>
                          }
                        />
                      )}
                  </>
                )}
              </div>
            )}

            <ProFormText
              name="name"
              label="设备名称"
              placeholder="如：核心交换机-A1"
              rules={[{ required: true, message: '请输入设备名称' }]}
            />
            <ProFormText
              name="assetCode"
              label="资产编码"
              placeholder="如：BJ-NET-SW-001"
              rules={[{ required: true, message: '请输入资产编码' }]}
            />
          </div>

          <div>
            <ProFormText
              name="serialNumber"
              label="序列号"
              placeholder="请输入设备序列号"
            />
            <ProFormText
              name="managementIp"
              label="管理IP"
              placeholder="如：10.0.1.1"
            />
            <ProFormDatePicker name="purchaseDate" label="采购日期" />
            <ProFormDatePicker name="warrantyExpiry" label="质保到期" />
            <ProFormText name="vendor" label="供应商" />
            <ProFormText name="owner" label="负责人" />
            <ProFormSelect
              name="department"
              label="所属部门"
              options={[
                { value: '网络运维部', label: '网络运维部' },
                { value: '应用开发部', label: '应用开发部' },
                { value: '数据库运维部', label: '数据库运维部' },
                { value: '安全运维部', label: '安全运维部' },
                { value: '存储运维部', label: '存储运维部' },
                { value: 'AI研发部', label: 'AI研发部' },
              ]}
            />
          </div>
        </div>
        <ProFormTextArea name="description" label="备注" />
      </ModalForm>

      {/* 编辑模态框 */}
      <ModalForm
        title="编辑设备"
        open={editModalOpen}
        onOpenChange={(open) => {
          setEditModalOpen(open);
          if (!open) resetEditForm();
        }}
        key={currentRow?.id}
        width={800}
        initialValues={currentRow}
        onFinishFailed={() => setEditActiveTab('basic')}
        onFinish={async (values) => {
          if (!currentRow) return false;
          if (editCabinetSlotsLoading) {
            setEditActiveTab('basic');
            message.warning('正在加载U位信息，请稍后');
            return false;
          }
          if (!editSelectedCabinetId || !editSelectedStartU) {
            setEditActiveTab('basic');
            message.error('请选择目标机柜和起始U位');
            return false;
          }
          if (editValidationSummary?.errors.length) {
            setEditActiveTab('basic');
            message.error('容量校验未通过，请调整上架位置或目标机柜');
            return false;
          }
          if (
            access.canAdmin &&
            sshVerificationToken &&
            sshKeyId &&
            !sshBindingUnchanged &&
            !sshTestResult?.connected
          ) {
            setEditActiveTab('ssh');
            message.error('新的 SSH 绑定必须先通过连接测试');
            return false;
          }
          const res = await updateDevice(currentRow.id, {
            ...values,
            cabinetId: editSelectedCabinetId,
            startU: editSelectedStartU,
            endU: editSelectedStartU + editDeviceUHeight - 1,
          });
          if (res.success) {
            if (access.canAdmin && sshVerificationToken) {
              const bindingResponse = await updateDeviceSshBinding(
                currentRow.id,
                {
                  keyId: sshKeyId,
                  username: sshUsername.trim(),
                  port: sshPort,
                },
                sshVerificationToken,
              );
              setSshBinding(bindingResponse.data || null);
            }
            message.success('更新成功');
            actionRef.current?.reload();
            return true;
          }
          return false;
        }}
      >
        <Tabs
          activeKey={editActiveTab}
          onChange={setEditActiveTab}
          items={[
            { key: 'basic', label: '基本信息' },
            ...(access.canAdmin ? [{ key: 'ssh', label: 'SSH 密钥' }] : []),
          ]}
        />
        <div style={{ display: editActiveTab === 'basic' ? 'block' : 'none' }}>
          <ProFormText
            name="name"
            label="设备名称"
            rules={[{ required: true }]}
          />
          <ProFormText
            name="assetCode"
            label="资产编码"
            rules={[{ required: true }]}
          />
          <ProFormSelect
            name="cabinetId"
            label="所在机柜"
            options={cabinets.map((c) => ({
              value: c.id,
              label: `${c.name} (${c.code}) - 剩余${(c.uHeight || 42) - (c.usedU || 0)}U`,
            }))}
            showSearch
            rules={[{ required: true, message: '请选择所在机柜' }]}
            fieldProps={{
              onChange: (value: string) => {
                setEditSelectedCabinetId(value);
                setEditSelectedStartU(undefined);
              },
            }}
          />
          {editSelectedCabinetId && currentRow && (
            <div style={{ marginBottom: 24 }}>
              <div style={{ marginBottom: 8, fontWeight: 500 }}>
                选择起始U位 <span style={{ color: '#f5222d' }}>*</span>
              </div>
              <USlotSelector
                cabinetId={editSelectedCabinetId}
                uHeight={editSelectedCabinet?.uHeight || 42}
                deviceUHeight={editDeviceUHeight}
                selectedStartU={editSelectedStartU}
                onSelect={setEditSelectedStartU}
                uUsage={editCabinetSlots}
                loading={editCabinetSlotsLoading}
              />
            </div>
          )}
          {editSelectedCabinetId && (
            <div style={{ marginBottom: 24 }}>
              <div style={{ marginBottom: 8, fontWeight: 500 }}>容量校验</div>
              {editCabinetSlotsLoading && <div>校验中...</div>}
              {!editCabinetSlotsLoading && (
                <>
                  {editValidationSummary?.errors?.length ? (
                    <Alert
                      type="error"
                      showIcon
                      message="校验未通过"
                      description={
                        <div>
                          {editValidationSummary.errors.map((e) => (
                            <div key={e}>{e}</div>
                          ))}
                        </div>
                      }
                    />
                  ) : (
                    <Alert type="success" showIcon message="基础容量校验通过" />
                  )}
                  {editValidationSummary?.warnings?.length ? (
                    <Alert
                      style={{ marginTop: 8 }}
                      type="warning"
                      showIcon
                      message="建议关注项"
                      description={
                        <div>
                          {editValidationSummary.warnings.map((w) => (
                            <div key={w}>{w}</div>
                          ))}
                        </div>
                      }
                    />
                  ) : null}
                </>
              )}
            </div>
          )}
          <ProFormText name="serialNumber" label="序列号" />
          <ProFormText name="managementIp" label="管理IP" />
        </div>
        {access.canAdmin && (
          <div style={{ display: editActiveTab === 'ssh' ? 'block' : 'none' }}>
            {!sshVerificationToken ? (
              <Alert
                showIcon
                type="info"
                message="需要验证管理员身份"
                description="选择密钥和测试连接前，需要再次验证当前管理员身份。"
                action={
                  <Button
                    htmlType="button"
                    icon={<ShieldCheck size={16} />}
                    onClick={() => setSshVerificationOpen(true)}
                  >
                    验证身份并加载密钥
                  </Button>
                }
              />
            ) : (
              <>
                <Alert
                  showIcon
                  type="info"
                  style={{ marginBottom: sshBinding ? 12 : 24 }}
                  message={`测试目标：${currentRow?.managementIp || '未设置管理 IP'}`}
                  description="连接测试会返回服务器主机指纹，但不会自动建立 known_hosts 信任；首次连接后请核对指纹。"
                />
                {sshBinding && (
                  <Alert
                    showIcon
                    type="success"
                    style={{ marginBottom: 24 }}
                    message={`当前绑定：${sshBinding.keyLabel} (${sshBinding.keyType})`}
                    description={`SSH 用户：${sshBinding.username} · 端口：${sshBinding.port}`}
                  />
                )}
                <Form.Item label="选择密钥" required>
                  <Select
                    allowClear
                    showSearch
                    optionFilterProp="label"
                    placeholder="选择密钥管理中的密钥"
                    style={{ width: '100%' }}
                    value={sshKeyId}
                    options={sshKeys.map((key) => ({
                      value: key.id,
                      label: `${key.label} (${key.keyType})`,
                    }))}
                    onChange={(value) => {
                      setSshKeyId(value);
                      setSshTestResult(null);
                    }}
                  />
                </Form.Item>
                <Form.Item label="SSH 用户名" required>
                  <Input
                    value={sshUsername}
                    placeholder="例如：root"
                    onChange={(event) => {
                      setSshUsername(event.target.value);
                      setSshTestResult(null);
                    }}
                  />
                </Form.Item>
                <Form.Item label="SSH 端口" required>
                  <InputNumber
                    min={1}
                    max={65535}
                    style={{ width: '100%' }}
                    value={sshPort}
                    onChange={(value) => {
                      setSshPort(value || 22);
                      setSshTestResult(null);
                    }}
                  />
                </Form.Item>
                <Form.Item
                  label="私钥口令"
                  extra="仅用于本次连接测试，不会保存。未加密的私钥可以留空。"
                >
                  <Input.Password
                    value={sshPassphrase}
                    placeholder="请输入私钥口令"
                    autoComplete="new-password"
                    onChange={(event) => setSshPassphrase(event.target.value)}
                  />
                </Form.Item>
                <Space style={{ marginBottom: sshTestResult ? 24 : 0 }}>
                  <Button
                    htmlType="button"
                    type="primary"
                    icon={<PlugZap size={16} />}
                    loading={sshTestLoading}
                    disabled={!currentRow?.managementIp || !sshKeyId}
                    onClick={runSshConnectionTest}
                  >
                    测试连接
                  </Button>
                </Space>
                {sshTestResult && (
                  <Alert
                    showIcon
                    type={sshTestResult.connected ? 'success' : 'error'}
                    message={
                      sshTestResult.connected
                        ? '连接测试通过，点击“确定”后保存当前绑定'
                        : `${sshStageText[sshTestResult.stage]}失败`
                    }
                    description={
                      <Descriptions size="small" column={1}>
                        <Descriptions.Item label="目标">
                          {sshTestResult.username}@{sshTestResult.host}:
                          {sshTestResult.port}
                        </Descriptions.Item>
                        <Descriptions.Item label="密钥">
                          {sshTestResult.keyLabel} ({sshTestResult.keyType})
                        </Descriptions.Item>
                        <Descriptions.Item label="阶段">
                          {sshStageText[sshTestResult.stage]}
                        </Descriptions.Item>
                        <Descriptions.Item label="耗时">
                          {sshTestResult.elapsedMs} ms
                        </Descriptions.Item>
                        {sshTestResult.serverFingerprint && (
                          <Descriptions.Item label="主机指纹">
                            <Typography.Text copyable>
                              {sshTestResult.serverFingerprint}
                            </Typography.Text>
                          </Descriptions.Item>
                        )}
                        {sshTestResult.algorithms?.kex && (
                          <Descriptions.Item label="协商算法">
                            {sshTestResult.algorithms.kex} /{' '}
                            {sshTestResult.algorithms.serverHostKey} /{' '}
                            {sshTestResult.algorithms.cipherClientToServer}
                          </Descriptions.Item>
                        )}
                        {sshTestResult.banner && (
                          <Descriptions.Item label="服务器信息">
                            {sshTestResult.banner}
                          </Descriptions.Item>
                        )}
                        {sshTestResult.errorMessage && (
                          <Descriptions.Item label="错误">
                            {sshTestResult.errorCode}:{' '}
                            {sshTestResult.errorMessage}
                          </Descriptions.Item>
                        )}
                      </Descriptions>
                    }
                  />
                )}
              </>
            )}
          </div>
        )}
        <div style={{ display: editActiveTab === 'basic' ? 'block' : 'none' }}>
          <ProFormSelect
            name="status"
            label="状态"
            options={[
              { value: 'online', label: '在线' },
              { value: 'offline', label: '离线' },
              { value: 'warning', label: '告警' },
              { value: 'error', label: '故障' },
              { value: 'maintenance', label: '维护中' },
            ]}
          />
          <ProFormDatePicker name="purchaseDate" label="采购日期" />
          <ProFormDatePicker name="warrantyExpiry" label="质保到期" />
          <ProFormText name="vendor" label="供应商" />
          <ProFormText name="owner" label="负责人" />
          <ProFormSelect
            name="department"
            label="所属部门"
            options={[
              { value: '网络运维部', label: '网络运维部' },
              { value: '应用开发部', label: '应用开发部' },
              { value: '数据库运维部', label: '数据库运维部' },
              { value: '安全运维部', label: '安全运维部' },
              { value: '存储运维部', label: '存储运维部' },
              { value: 'AI研发部', label: 'AI研发部' },
            ]}
          />
          <ProFormTextArea name="description" label="备注" />
        </div>
      </ModalForm>

      <Modal
        title={
          <Space>
            <ShieldCheck size={18} />
            验证管理员身份
          </Space>
        }
        open={sshVerificationOpen}
        okText="验证并加载"
        cancelText="取消"
        confirmLoading={sshVerificationLoading}
        destroyOnHidden
        onOk={verifyAndLoadSshBinding}
        onCancel={() => {
          setSshVerificationOpen(false);
          setSshVerificationPassword('');
        }}
      >
        <Typography.Paragraph type="secondary">
          SSH 密钥属于敏感凭据，请输入当前管理员账户密码完成二次验证。
        </Typography.Paragraph>
        <Input.Password
          autoFocus
          value={sshVerificationPassword}
          placeholder="当前管理员账户密码"
          onChange={(event) => setSshVerificationPassword(event.target.value)}
          onPressEnter={verifyAndLoadSshBinding}
        />
      </Modal>

      {/* 详情抽屉 */}
      <Drawer
        title="设备详情"
        open={detailDrawerOpen}
        onClose={() => setDetailDrawerOpen(false)}
        width={500}
      >
        {currentRow && (
          <Descriptions bordered column={1} size="small">
            <Descriptions.Item label="设备名称">
              <Space>
                <Badge
                  status={
                    currentRow.status === 'online' ? 'success' : 'default'
                  }
                />
                {currentRow.name}
              </Space>
            </Descriptions.Item>
            <Descriptions.Item label="资产编码">
              {currentRow.assetCode}
            </Descriptions.Item>
            <Descriptions.Item label="序列号">
              {currentRow.serialNumber || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="设备型号">
              {templates.find((t) => t.id === currentRow.templateId)?.name ||
                currentRow.templateId}
            </Descriptions.Item>
            <Descriptions.Item label="所在机柜">
              {cabinets.find((c) => c.id === currentRow.cabinetId)?.name ||
                currentRow.cabinetId}
            </Descriptions.Item>
            <Descriptions.Item label="U位">
              U{currentRow.startU} - U{currentRow.endU}
            </Descriptions.Item>
            <Descriptions.Item label="管理IP">
              {currentRow.managementIp || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="状态">
              <Tag color={statusConfig[currentRow.status]?.color}>
                {statusConfig[currentRow.status]?.text}
              </Tag>
            </Descriptions.Item>
            <Descriptions.Item label="采购日期">
              {currentRow.purchaseDate || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="质保到期">
              {currentRow.warrantyExpiry || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="供应商">
              {currentRow.vendor || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="负责人">
              {currentRow.owner || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="所属部门">
              {currentRow.department || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="备注">
              {currentRow.description || '-'}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Drawer>

      {/* 端口详情视图 */}
      <DevicePortView
        device={portViewDevice}
        template={
          portViewDevice
            ? templates.find((t) => t.id === portViewDevice.templateId)
            : null
        }
        open={portViewOpen}
        onClose={() => {
          setPortViewOpen(false);
          setPortViewDevice(null);
        }}
      />
    </PageContainer>
  );
};

export default DevicePage;
