import { PageContainer } from '@ant-design/pro-components';
import { ProTable, ModalForm, ProForm, ProFormText, ProFormTextArea, ProFormSelect, ProFormDigit } from '@ant-design/pro-components';
import type { ProColumns, ActionType } from '@ant-design/pro-components';
import { Alert, Button, Descriptions, Empty, Form, message, Modal, Popconfirm, Progress, Space, Spin, Tabs, Tag, Tooltip } from 'antd';
import { useRef, useState, useEffect } from 'react';
import {
    Server,
    Plus,
    Edit3,
    Trash2,
    Zap,
    LayoutGrid,
    Box,
} from 'lucide-react';
import { history } from '@umijs/max';
import {
    getCabinets,
    createCabinet,
    updateCabinet,
    deleteCabinet,
    getCabinetTelemetrySource,
    saveCabinetTelemetrySource,
    testCabinetTelemetrySource,
} from '@/services/idc/cabinet';
import { getDevices } from '@/services/idc/device';
import { getAllDatacenters } from '@/services/idc/datacenter';
import { getAllDeviceTemplates } from '@/services/idc/deviceTemplate';
import CabinetFrontView from '@/components/CabinetFrontView';

type TelemetrySourceFormValues = {
    id: string;
    host: string;
    port: number;
    unitId: number;
    timeoutMs: number;
    enabled: boolean;
};

const formatTelemetryValue = (value: unknown) => {
    if (value === null || value === undefined || value === '') return '-';
    if (typeof value === 'boolean') return value ? 'true' : 'false';
    if (typeof value === 'object') return JSON.stringify(value);
    return String(value);
};

const CabinetPage: React.FC = () => {
    const actionRef = useRef<ActionType>(null);
    const [createModalOpen, setCreateModalOpen] = useState(false);
    const [editModalOpen, setEditModalOpen] = useState(false);
    const [currentRow, setCurrentRow] = useState<IDC.Cabinet>();
    const [datacenters, setDatacenters] = useState<{ id: string; name: string }[]>([]);
    const [cabinetEditForm] = Form.useForm();
    const [telemetryForm] = Form.useForm();
    const [telemetryLoading, setTelemetryLoading] = useState(false);
    const [telemetryTestOpen, setTelemetryTestOpen] = useState(false);
    const [telemetryTestConfig, setTelemetryTestConfig] = useState<TelemetrySourceFormValues>();
    const [telemetryTestData, setTelemetryTestData] = useState<Record<string, unknown>>();
    const [telemetryTestError, setTelemetryTestError] = useState<string>();
    const [telemetryTestRefreshing, setTelemetryTestRefreshing] = useState(false);
    const [telemetryTestUpdatedAt, setTelemetryTestUpdatedAt] = useState<Date>();

    // 机柜使用详情视图状态
    const [frontViewOpen, setFrontViewOpen] = useState(false);
    const [viewCabinet, setViewCabinet] = useState<IDC.Cabinet | null>(null);
    const [cabinetDevices, setCabinetDevices] = useState<IDC.Device[]>([]);
    const [templates, setTemplates] = useState<any[]>([]);
    const [_loadingDevices, setLoadingDevices] = useState(false);

    useEffect(() => {
        getAllDatacenters().then(res => {
            if (res.success) {
                setDatacenters(res.data || []);
            }
        });
        getAllDeviceTemplates().then(res => {
            if (res.success) {
                setTemplates(res.data || []);
            }
        });
    }, []);

    useEffect(() => {
        if (!editModalOpen || !currentRow) return;
        let cancelled = false;
        cabinetEditForm.setFieldsValue(currentRow);
        telemetryForm.resetFields();
        setTelemetryLoading(true);
        getCabinetTelemetrySource(currentRow.id)
            .then((res) => {
                if (cancelled) return;
                telemetryForm.setFieldsValue(res.data || {
                    id: `${currentRow.code}-Telemery`,
                    host: '',
                    port: 502,
                    unitId: 1,
                    timeoutMs: 1800,
                    enabled: true,
                });
            })
            .catch((error) => {
                if (!cancelled) {
                    message.error(error instanceof Error ? error.message : '读取遥测采集配置失败');
                }
            })
            .finally(() => {
                if (!cancelled) setTelemetryLoading(false);
            });
        return () => {
            cancelled = true;
        };
    }, [cabinetEditForm, currentRow, editModalOpen, telemetryForm]);

    useEffect(() => {
        if (!telemetryTestOpen || !telemetryTestConfig || !currentRow) return;
        let cancelled = false;
        let inFlight = false;

        const collect = async () => {
            if (inFlight) return;
            inFlight = true;
            setTelemetryTestRefreshing(true);
            try {
                const res = await testCabinetTelemetrySource(currentRow.id, telemetryTestConfig);
                if (!cancelled) {
                    setTelemetryTestData({ ...res.data });
                    setTelemetryTestError(undefined);
                    setTelemetryTestUpdatedAt(new Date());
                }
            } catch (error) {
                if (!cancelled) {
                    setTelemetryTestError(
                        error instanceof Error ? error.message : '遥测数据采集测试失败',
                    );
                }
            } finally {
                if (!cancelled) {
                    setTelemetryTestRefreshing(false);
                }
                inFlight = false;
            }
        };

        void collect();
        const timer = window.setInterval(() => void collect(), 2000);
        return () => {
            cancelled = true;
            window.clearInterval(timer);
        };
    }, [currentRow, telemetryTestConfig, telemetryTestOpen]);

    const handleOpenTelemetryTest = async () => {
        const values = await telemetryForm.validateFields([
            'id',
            'host',
            'port',
            'unitId',
            'timeoutMs',
            'enabled',
        ]) as TelemetrySourceFormValues;
        setTelemetryTestConfig(values);
        setTelemetryTestData(undefined);
        setTelemetryTestError(undefined);
        setTelemetryTestUpdatedAt(undefined);
        setTelemetryTestOpen(true);
    };

    // 查看机柜使用详情
    const handleViewUsage = async (cabinet: IDC.Cabinet) => {
        setViewCabinet(cabinet);
        setLoadingDevices(true);
        setFrontViewOpen(true);

        // 获取该机柜下的设备
        const res = await getDevices({ pageSize: 1000, cabinetId: cabinet.id });
        if (res.success) {
            setCabinetDevices(res.data || []);
        }
        setLoadingDevices(false);
    };

    const statusMap: Record<string, { color: string; text: string }> = {
        normal: { color: 'success', text: '正常' },
        warning: { color: 'warning', text: '告警' },
        error: { color: 'error', text: '故障' },
        offline: { color: 'default', text: '离线' },
    };

    const columns: ProColumns<IDC.Cabinet>[] = [
        {
            title: '机柜名称',
            dataIndex: 'name',
            ellipsis: true,
            render: (_, record) => (
                <Space>
                    <Server size={16} style={{ color: '#722ed1' }} />
                    <span style={{ fontWeight: 500 }}>{record.name}</span>
                </Space>
            ),
        },
        {
            title: '机柜编码',
            dataIndex: 'code',
            width: 160,
            copyable: true,
        },
        {
            title: '所属数据中心',
            dataIndex: 'datacenterId',
            width: 160,
            valueType: 'select',
            fieldProps: {
                options: datacenters.map(dc => ({ value: dc.id, label: dc.name })),
            },
            render: (_, record) => record.datacenterName || '-',
        },
        {
            title: '位置',
            dataIndex: 'row',
            width: 100,
            search: false,
            render: (_, record) => `${record.row}排${record.column}列`,
        },
        {
            title: 'U位使用',
            dataIndex: 'usedU',
            width: 180,
            search: false,
            render: (_, record) => {
                const usage = record.usedU / record.uHeight;
                return (
                    <Tooltip title={`${record.usedU}U / ${record.uHeight}U`}>
                        <div style={{ width: 120 }}>
                            <Progress
                                percent={usage * 100}
                                size="small"
                                strokeColor={usage > 0.9 ? '#f5222d' : usage > 0.7 ? '#faad14' : '#52c41a'}
                                format={() => `${record.usedU}/${record.uHeight}U`}
                            />
                        </div>
                    </Tooltip>
                );
            },
        },
        {
            title: '功率',
            dataIndex: 'currentPower',
            width: 150,
            search: false,
            render: (_, record) => {
                const usage = record.currentPower / record.maxPower;
                return (
                    <Tooltip title={`${record.currentPower}W / ${record.maxPower}W`}>
                        <Space>
                            <Zap size={14} style={{ color: usage > 0.8 ? '#f5222d' : '#faad14' }} />
                            <span>{(record.currentPower / 1000).toFixed(1)}kW</span>
                        </Space>
                    </Tooltip>
                );
            },
        },
        {
            title: '状态',
            dataIndex: 'status',
            width: 80,
            valueType: 'select',
            valueEnum: {
                normal: { text: '正常', status: 'Success' },
                warning: { text: '告警', status: 'Warning' },
                error: { text: '故障', status: 'Error' },
                offline: { text: '离线', status: 'Default' },
            },
            render: (_, record) => (
                <Tag color={statusMap[record.status]?.color}>
                    {statusMap[record.status]?.text}
                </Tag>
            ),
        },
        {
            title: '更新时间',
            dataIndex: 'updatedAt',
            width: 170,
            valueType: 'dateTime',
            search: false,
            sorter: true,
        },
        {
            title: '操作',
            valueType: 'option',
            width: 360,
            fixed: 'right',
            render: (_, record) => [
                <Tooltip key="3d" title="查看3D机柜视图">
                    <Button
                        type="link"
                        size="small"
                        icon={<Box size={14} />}
                        onClick={() => history.push(`/cabinet3d?id=${record.id}`)}
                    >
                        3D视图
                    </Button>
                </Tooltip>,
                <Tooltip key="view" title="查看机柜U位使用详情">
                    <Button
                        type="link"
                        size="small"
                        icon={<LayoutGrid size={14} />}
                        onClick={() => handleViewUsage(record)}
                    >
                        使用详情
                    </Button>
                </Tooltip>,
                <Button
                    key="edit"
                    type="link"
                    size="small"
                    icon={<Edit3 size={14} />}
                    onClick={() => {
                        setCurrentRow(record);
                        setEditModalOpen(true);
                    }}
                >
                    编辑
                </Button>,
                <Popconfirm
                    key="delete"
                    title="确定要删除这个机柜吗？"
                    onConfirm={async () => {
                        const res = await deleteCabinet(record.id);
                        if (res.success) {
                            message.success('删除成功');
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
                title: '机柜管理',
                subTitle: '管理数据中心机柜信息',
            }}
        >
            <ProTable<IDC.Cabinet>
                headerTitle="机柜列表"
                actionRef={actionRef}
                rowKey="id"
                columns={columns}
                scroll={{ x: 1500 }}
                request={async (params) => {
                    const res = await getCabinets({
                        current: params.current,
                        pageSize: params.pageSize,
                        datacenterId: params.datacenterId,
                        name: params.name,
                        status: params.status,
                        code: params.code,
                    });
                    return {
                        data: res.data || [],
                        success: res.success,
                        total: res.total || 0,
                    };
                }}
                toolBarRender={() => [
                    <Button
                        key="create"
                        type="primary"
                        icon={<Plus size={16} />}
                        onClick={() => setCreateModalOpen(true)}
                    >
                        新建机柜
                    </Button>,
                ]}
            />

            {/* 新建模态框 */}
            <ModalForm
                title="新建机柜"
                open={createModalOpen}
                onOpenChange={setCreateModalOpen}
                width={600}
                onFinish={async (values) => {
                    const res = await createCabinet(values as IDC.CabinetCreateParams);
                    if (res.success) {
                        message.success('创建成功');
                        actionRef.current?.reload();
                        return true;
                    }
                    return false;
                }}
            >
                <ProFormSelect
                    name="datacenterId"
                    label="所属数据中心"
                    options={datacenters.map(dc => ({ value: dc.id, label: dc.name }))}
                    rules={[{ required: true, message: '请选择数据中心' }]}
                />
                <ProFormText
                    name="name"
                    label="机柜名称"
                    placeholder="如：A区1排1号机柜"
                    rules={[{ required: true, message: '请输入机柜名称' }]}
                />
                <ProFormText
                    name="code"
                    label="机柜编码"
                    placeholder="如：BJ-YZ-A1-01"
                    rules={[{ required: true, message: '请输入机柜编码' }]}
                />
                <Space size={16}>
                    <ProFormDigit
                        name="row"
                        label="行号"
                        width="sm"
                        min={1}
                        rules={[{ required: true, message: '请输入行号' }]}
                    />
                    <ProFormDigit
                        name="column"
                        label="列号"
                        width="sm"
                        min={1}
                        rules={[{ required: true, message: '请输入列号' }]}
                    />
                </Space>
                <ProFormSelect
                    name="uHeight"
                    label="U位高度"
                    initialValue={42}
                    options={[
                        { value: 42, label: '42U' },
                        { value: 47, label: '47U' },
                        { value: 48, label: '48U' },
                    ]}
                />
                <ProFormDigit
                    name="maxPower"
                    label="最大功率(W)"
                    initialValue={10000}
                    min={1000}
                    fieldProps={{ step: 1000 }}
                />
                <ProFormTextArea
                    name="description"
                    label="描述"
                    placeholder="请输入描述信息"
                />
            </ModalForm>

            {/* 编辑机柜：基础信息与遥测采集配置分别保存 */}
            <Modal
                title={`编辑机柜${currentRow ? ` - ${currentRow.name}` : ''}`}
                open={editModalOpen}
                onCancel={() => setEditModalOpen(false)}
                footer={null}
                width={720}
                destroyOnHidden
            >
                <Tabs
                    items={[
                        {
                            key: 'base',
                            label: '基础信息',
                            children: (
                                <ProForm
                                    form={cabinetEditForm}
                                    layout="vertical"
                                    submitter={{
                                        searchConfig: { submitText: '保存机柜信息' },
                                        resetButtonProps: false,
                                    }}
                                    onFinish={async (values) => {
                                        if (!currentRow) return false;
                                        const res = await updateCabinet(currentRow.id, values);
                                        if (!res.success) return false;
                                        message.success('机柜基础信息已保存');
                                        actionRef.current?.reload();
                                        return true;
                                    }}
                                >
                                    <ProFormSelect
                                        name="datacenterId"
                                        label="所属数据中心"
                                        options={datacenters.map(dc => ({ value: dc.id, label: dc.name }))}
                                        rules={[{ required: true }]}
                                    />
                                    <ProFormText name="name" label="机柜名称" rules={[{ required: true }]} />
                                    <ProFormText name="code" label="机柜编码" rules={[{ required: true }]} />
                                    <Space size={16}>
                                        <ProFormDigit name="row" label="行号" width="sm" min={1} rules={[{ required: true }]} />
                                        <ProFormDigit name="column" label="列号" width="sm" min={1} rules={[{ required: true }]} />
                                    </Space>
                                    <ProFormSelect
                                        name="status"
                                        label="状态"
                                        options={[
                                            { value: 'normal', label: '正常' },
                                            { value: 'warning', label: '告警' },
                                            { value: 'error', label: '故障' },
                                            { value: 'offline', label: '离线' },
                                        ]}
                                    />
                                    <ProFormDigit name="maxPower" label="最大功率(W)" min={1000} />
                                    <ProFormTextArea name="description" label="描述" />
                                </ProForm>
                            ),
                        },
                        {
                            key: 'telemetry',
                            label: '遥测采集配置',
                            children: (
                                <Spin spinning={telemetryLoading}>
                                    <Alert
                                        type="info"
                                        showIcon
                                        message="该配置独立保存"
                                        description="保存后后端会立即重载采集任务。高低频周期仍由服务端 .env 统一配置。"
                                        style={{ marginBottom: 16 }}
                                    />
                                    <ProForm
                                        form={telemetryForm}
                                        layout="vertical"
                                        submitter={{
                                            searchConfig: { submitText: '保存遥测采集配置' },
                                            resetButtonProps: false,
                                            render: (_, buttons) => [
                                                <Button
                                                    key="test-telemetry"
                                                    onClick={() => void handleOpenTelemetryTest()}
                                                >
                                                    测试遥测数据采集
                                                </Button>,
                                                ...buttons,
                                            ],
                                        }}
                                        onFinish={async (values) => {
                                            if (!currentRow) return false;
                                            const telemetryValues = values as TelemetrySourceFormValues;
                                            const res = await saveCabinetTelemetrySource(
                                                currentRow.id,
                                                {
                                                    id: telemetryValues.id,
                                                    host: telemetryValues.host,
                                                    port: telemetryValues.port,
                                                    unitId: telemetryValues.unitId,
                                                    timeoutMs: telemetryValues.timeoutMs,
                                                    enabled: telemetryValues.enabled,
                                                },
                                            );
                                            if (!res.success) return false;
                                            telemetryForm.setFieldsValue(res.data);
                                            message.success('遥测采集配置已保存并生效');
                                            return true;
                                        }}
                                    >
                                        <ProFormSelect
                                            name="enabled"
                                            label="采集状态"
                                            options={[
                                                { value: true, label: '启用' },
                                                { value: false, label: '停用' },
                                            ]}
                                            rules={[{ required: true }]}
                                        />
                                        <ProFormText
                                            name="id"
                                            label="采集源标识"
                                            tooltip="所有机柜的采集源标识必须唯一"
                                            rules={[
                                                { required: true, message: '请输入采集源标识' },
                                                { pattern: /^[A-Za-z0-9._:-]+$/, message: '仅允许字母、数字、点、下划线、冒号和连字符' },
                                            ]}
                                        />
                                        <ProFormText
                                            name="protocol"
                                            label="采集协议"
                                            initialValue="Modbus TCP"
                                            fieldProps={{ disabled: true }}
                                        />
                                        <ProFormText
                                            name="host"
                                            label="主机地址"
                                            placeholder="例如：192.168.244.144"
                                            rules={[{ required: true, message: '请输入主机地址' }]}
                                        />
                                        <Space size={16}>
                                            <ProFormDigit
                                                name="port"
                                                label="端口"
                                                width="sm"
                                                min={1}
                                                max={65535}
                                                rules={[{ required: true }]}
                                            />
                                            <ProFormDigit
                                                name="unitId"
                                                label="Unit ID"
                                                width="sm"
                                                min={0}
                                                max={255}
                                                rules={[{ required: true }]}
                                            />
                                            <ProFormDigit
                                                name="timeoutMs"
                                                label="超时(ms)"
                                                width="sm"
                                                min={100}
                                                rules={[{ required: true }]}
                                            />
                                        </Space>
                                    </ProForm>
                                </Spin>
                            ),
                        },
                    ]}
                />
            </Modal>

            <Modal
                title={`遥测数据采集测试${currentRow ? ` - ${currentRow.name}` : ''}`}
                open={telemetryTestOpen}
                onCancel={() => setTelemetryTestOpen(false)}
                footer={[
                    <Button key="close" onClick={() => setTelemetryTestOpen(false)}>
                        关闭
                    </Button>,
                ]}
                width={900}
                destroyOnHidden
            >
                <Alert
                    type={telemetryTestError ? 'error' : 'info'}
                    showIcon
                    message={telemetryTestError || '正在每隔 2 秒采集并刷新当前最新值'}
                    description={
                        telemetryTestUpdatedAt
                            ? `最近成功采集：${telemetryTestUpdatedAt.toLocaleTimeString('zh-CN')}`
                            : '打开弹窗后立即执行第一次采集'
                    }
                    style={{ marginBottom: 16 }}
                />
                <Spin spinning={telemetryTestRefreshing && !telemetryTestData}>
                    {telemetryTestData ? (
                        <Descriptions
                            bordered
                            size="small"
                            column={2}
                            items={Object.entries(telemetryTestData).map(([fieldName, value]) => ({
                                key: fieldName,
                                label: fieldName,
                                children: formatTelemetryValue(value),
                            }))}
                        />
                    ) : (
                        <Empty description="等待遥测数据" />
                    )}
                </Spin>
            </Modal>

            {/* 机柜使用详情视图 */}
            <CabinetFrontView
                cabinet={viewCabinet}
                devices={cabinetDevices}
                templates={templates}
                open={frontViewOpen}
                onClose={() => {
                    setFrontViewOpen(false);
                    setViewCabinet(null);
                    setCabinetDevices([]);
                }}
                onDeviceClick={(device) => {
                    message.info(`设备: ${device.name} (IP: ${device.managementIp || '-'})`);
                }}
            />
        </PageContainer>
    );
};

export default CabinetPage;
