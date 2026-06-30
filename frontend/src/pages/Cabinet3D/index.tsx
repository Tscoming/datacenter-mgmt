import { PageContainer } from '@ant-design/pro-components';
import { history, useSearchParams } from '@umijs/max';
import { Card, Descriptions, Empty, Space, Spin, Tag, Typography } from 'antd';
import { Server } from 'lucide-react';
import { useEffect, useMemo, useState } from 'react';
import { CabinetFrontViewContent } from '@/components/CabinetFrontView';
import { getCabinet } from '@/services/idc/cabinet';
import { getDevicesByCabinet } from '@/services/idc/device';
import { getAllDeviceTemplates } from '@/services/idc/deviceTemplate';
import styles from './index.less';

const { Text } = Typography;

const statusMap: Record<string, { color: string; text: string }> = {
  online: { color: 'success', text: '在线' },
  offline: { color: 'default', text: '离线' },
  warning: { color: 'warning', text: '告警' },
  error: { color: 'error', text: '故障' },
  maintenance: { color: 'processing', text: '维护' },
};

const booleanText = (value?: boolean) => {
  if (value === undefined || value === null) return '-';
  return value ? '是' : '否';
};

const text = (value?: string | number | null) => {
  if (value === undefined || value === null || value === '') return '-';
  return String(value);
};

interface DeviceDetailProps {
  device: IDC.Device | null;
  template?: any;
  cabinet?: IDC.Cabinet | null;
}

const DeviceDetail: React.FC<DeviceDetailProps> = ({
  device,
  template,
  cabinet,
}) => {
  if (!device) {
    return (
      <Card className={styles.detailCard}>
        <Empty description="点击左侧机柜中的设备查看详细属性" />
      </Card>
    );
  }

  const status = statusMap[device.status] || {
    color: 'default',
    text: device.status,
  };

  return (
    <Card
      className={styles.detailCard}
      title={
        <Space>
          <Server size={16} />
          <span>设备详细属性</span>
        </Space>
      }
    >
      <div className={styles.deviceHeader}>
        <div>
          <h3>{device.name}</h3>
          <Text type="secondary">{text(device.assetCode)}</Text>
        </div>
        <Tag color={status.color}>{status.text}</Tag>
      </div>

      <Descriptions column={1} bordered size="small">
        <Descriptions.Item label="设备ID">{device.id}</Descriptions.Item>
        <Descriptions.Item label="资产编码">
          {text(device.assetCode)}
        </Descriptions.Item>
        <Descriptions.Item label="设备名称">
          {text(device.name)}
        </Descriptions.Item>
        <Descriptions.Item label="运行状态">
          <Tag color={status.color}>{status.text}</Tag>
        </Descriptions.Item>
        <Descriptions.Item label="所属机柜">
          {cabinet ? `${cabinet.name} (${cabinet.code})` : text(device.cabinetId)}
        </Descriptions.Item>
        <Descriptions.Item label="U位">
          U{device.startU}
          {device.startU !== device.endU ? `-U${device.endU}` : ''}
        </Descriptions.Item>
        <Descriptions.Item label="管理IP">
          {text(device.managementIp)}
        </Descriptions.Item>
        <Descriptions.Item label="序列号">
          {text(device.serialNumber)}
        </Descriptions.Item>
        <Descriptions.Item label="供应商">{text(device.vendor)}</Descriptions.Item>
        <Descriptions.Item label="负责人">{text(device.owner)}</Descriptions.Item>
        <Descriptions.Item label="所属部门">
          {text(device.department)}
        </Descriptions.Item>
        <Descriptions.Item label="是否已上架">
          {booleanText(device.isMounted)}
        </Descriptions.Item>
        <Descriptions.Item label="采购日期">
          {text(device.purchaseDate)}
        </Descriptions.Item>
        <Descriptions.Item label="质保到期">
          {text(device.warrantyExpiry)}
        </Descriptions.Item>
        <Descriptions.Item label="描述">
          {text(device.description)}
        </Descriptions.Item>
        <Descriptions.Item label="创建时间">
          {text(device.createdAt)}
        </Descriptions.Item>
        <Descriptions.Item label="更新时间">
          {text(device.updatedAt)}
        </Descriptions.Item>
      </Descriptions>

      <div className={styles.sectionTitle}>模板信息</div>
      <Descriptions column={1} bordered size="small">
        <Descriptions.Item label="模板名称">
          {text(template?.name)}
        </Descriptions.Item>
        <Descriptions.Item label="设备类型">
          {text(template?.category)}
        </Descriptions.Item>
        <Descriptions.Item label="品牌">{text(template?.brand)}</Descriptions.Item>
        <Descriptions.Item label="型号">{text(template?.model)}</Descriptions.Item>
        <Descriptions.Item label="高度">
          {template?.uHeight ? `${template.uHeight}U` : '-'}
        </Descriptions.Item>
        <Descriptions.Item label="最大功率">
          {template?.maxPower ? `${template.maxPower}W` : '-'}
        </Descriptions.Item>
      </Descriptions>
    </Card>
  );
};

const Cabinet3DPage: React.FC = () => {
  const [searchParams] = useSearchParams();
  const cabinetId = searchParams.get('id');

  const [loading, setLoading] = useState(true);
  const [cabinet, setCabinet] = useState<IDC.Cabinet | null>(null);
  const [devices, setDevices] = useState<IDC.Device[]>([]);
  const [templates, setTemplates] = useState<any[]>([]);
  const [selectedDevice, setSelectedDevice] = useState<IDC.Device | null>(null);

  useEffect(() => {
    if (!cabinetId) {
      setLoading(false);
      return;
    }

    const loadCabinetData = async () => {
      setLoading(true);
      try {
        const [cabinetRes, devicesRes, templatesRes] = await Promise.all([
          getCabinet(cabinetId),
          getDevicesByCabinet(cabinetId),
          getAllDeviceTemplates(),
        ]);

        setCabinet(cabinetRes.success ? cabinetRes.data || null : null);
        setDevices(devicesRes.success ? devicesRes.data || [] : []);
        setTemplates(templatesRes.success ? templatesRes.data || [] : []);
        setSelectedDevice(null);
      } finally {
        setLoading(false);
      }
    };

    loadCabinetData();
  }, [cabinetId]);

  const selectedTemplate = useMemo(
    () => templates.find((item) => item.id === selectedDevice?.templateId),
    [selectedDevice, templates],
  );

  if (!cabinetId) {
    return (
      <PageContainer>
        <Empty description="未指定机柜ID" />
      </PageContainer>
    );
  }

  return (
    <PageContainer
      header={{
        title: cabinet?.name || '机柜视图',
        subTitle: cabinet
          ? `${cabinet.code} | ${cabinet.row}排${cabinet.column}列`
          : '',
        onBack: () => history.back(),
      }}
    >
      <Spin spinning={loading}>
        {cabinet ? (
          <div className={styles.page}>
            <Card className={styles.usageCard} bodyStyle={{ padding: 0 }}>
              <CabinetFrontViewContent
                cabinet={cabinet}
                devices={devices}
                templates={templates}
                selectedDeviceId={selectedDevice?.id}
                onDeviceClick={setSelectedDevice}
              />
            </Card>

            <DeviceDetail
              cabinet={cabinet}
              device={selectedDevice}
              template={selectedTemplate}
            />
          </div>
        ) : (
          !loading && <Empty description="未找到机柜数据" />
        )}
      </Spin>
    </PageContainer>
  );
};

export default Cabinet3DPage;
