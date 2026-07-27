import {
  ModalForm,
  PageContainer,
  ProForm,
  ProFormRadio,
  ProFormSelect,
  ProFormText,
  ProFormTextArea,
} from '@ant-design/pro-components';
import { history } from '@umijs/max';
import {
  Button,
  Card,
  Col,
  Drawer,
  Empty,
  Input,
  Modal,
  message,
  Popconfirm,
  Row,
  Space,
  Spin,
  Tag,
  Typography,
  Upload,
} from 'antd';
import {
  KeyRound,
  Plus,
  Search,
  ShieldCheck,
  Sparkles,
  Trash2,
  Upload as UploadIcon,
} from 'lucide-react';
import { useCallback, useEffect, useState } from 'react';
import {
  createManagedKey,
  deleteManagedKey,
  type GenerateManagedKeyPayload,
  generateManagedKey,
  getManagedKey,
  getManagedKeys,
  type ManagedKey,
  type ManagedKeyPayload,
  updateManagedKey,
  verifyKeyManagement,
} from '@/services/system/keyManagement';
import styles from './index.less';

const keyTypeOptions = ['RSA', 'ED25519', 'ECDSA', 'OTHER'].map((value) => ({
  label: value === 'OTHER' ? '其他' : value,
  value,
}));

const KeyManagementPage: React.FC = () => {
  const [verificationOpen, setVerificationOpen] = useState(true);
  const [verificationLoading, setVerificationLoading] = useState(false);
  const [verificationToken, setVerificationToken] = useState('');
  const [password, setPassword] = useState('');
  const [keys, setKeys] = useState<ManagedKey[]>([]);
  const [loading, setLoading] = useState(false);
  const [keyword, setKeyword] = useState('');
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [generateOpen, setGenerateOpen] = useState(false);
  const [editingKey, setEditingKey] = useState<ManagedKey>();
  const [detailLoading, setDetailLoading] = useState(false);
  const [form] = ProForm.useForm<ManagedKeyPayload>();

  const loadKeys = useCallback(
    async (token: string, searchKeyword = keyword) => {
      setLoading(true);
      try {
        const response = await getManagedKeys(token, searchKeyword);
        setKeys(response.data);
      } finally {
        setLoading(false);
      }
    },
    [keyword],
  );

  useEffect(() => {
    if (!verificationToken) return;
    const timeout = window.setTimeout(
      () => {
        setVerificationToken('');
        setVerificationOpen(true);
        setDrawerOpen(false);
        message.warning('安全验证已过期，请重新验证');
      },
      5 * 60 * 1000,
    );
    return () => window.clearTimeout(timeout);
  }, [verificationToken]);

  const handleVerify = async () => {
    if (!password) {
      message.warning('请输入当前账户密码');
      return;
    }
    setVerificationLoading(true);
    try {
      const response = await verifyKeyManagement(password);
      setVerificationToken(response.data.verificationToken);
      setVerificationOpen(false);
      setPassword('');
      await loadKeys(response.data.verificationToken, '');
    } finally {
      setVerificationLoading(false);
    }
  };

  const openCreate = () => {
    setEditingKey(undefined);
    form.resetFields();
    form.setFieldsValue({ keyType: 'RSA' });
    setDrawerOpen(true);
  };

  const openEdit = async (key: ManagedKey) => {
    setDrawerOpen(true);
    setDetailLoading(true);
    try {
      const response = await getManagedKey(key.id, verificationToken);
      setEditingKey(response.data);
      form.setFieldsValue(response.data);
    } finally {
      setDetailLoading(false);
    }
  };

  return (
    <PageContainer
      title="密钥管理"
      subTitle="集中保管 SSH 私钥、公钥与证书"
      extra={
        <Tag icon={<ShieldCheck size={13} />}>管理员专用 · 已二次验证</Tag>
      }
    >
      <div className={styles.toolbar}>
        <Input
          className={styles.search}
          allowClear
          prefix={<Search size={16} />}
          placeholder="搜索密钥名称或备注"
          value={keyword}
          onChange={(event) => setKeyword(event.target.value)}
          onPressEnter={() => loadKeys(verificationToken)}
        />
        <Space>
          <Button
            icon={<Sparkles size={16} />}
            onClick={() => setGenerateOpen(true)}
          >
            生成新的密钥
          </Button>
          <Button type="primary" icon={<Plus size={16} />} onClick={openCreate}>
            新建密钥
          </Button>
        </Space>
      </div>

      <Spin spinning={loading}>
        {keys.length ? (
          <Row gutter={[16, 16]}>
            {keys.map((key) => (
              <Col key={key.id} xs={24} md={12} xl={8}>
                <Card className={styles.keyCard} onClick={() => openEdit(key)}>
                  <Space align="start" size={14}>
                    <span className={styles.keyIcon}>
                      <KeyRound size={22} />
                    </span>
                    <Space direction="vertical" size={2}>
                      <span className={styles.keyTitle}>{key.label}</span>
                      <span className={styles.keyMeta}>类型 {key.keyType}</span>
                      <Typography.Text type="secondary" ellipsis>
                        {key.description || '暂无备注'}
                      </Typography.Text>
                    </Space>
                  </Space>
                </Card>
              </Col>
            ))}
          </Row>
        ) : (
          <div className={styles.empty}>
            <Empty description="还没有密钥">
              <Button type="primary" onClick={openCreate}>
                新建第一个密钥
              </Button>
            </Empty>
          </div>
        )}
      </Spin>

      <Modal
        title={
          <Space>
            <ShieldCheck size={20} />
            进入密钥管理前需要二次验证
          </Space>
        }
        open={verificationOpen}
        confirmLoading={verificationLoading}
        okText="验证并进入"
        cancelText="返回"
        closable={false}
        maskClosable={false}
        keyboard={false}
        onOk={handleVerify}
        onCancel={() => history.push('/system/users')}
      >
        <Typography.Paragraph type="secondary">
          这里保存了敏感凭据。请输入当前管理员账户的密码以确认身份，验证结果 5
          分钟内有效。
        </Typography.Paragraph>
        <Input.Password
          autoFocus
          placeholder="当前账户密码"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          onPressEnter={handleVerify}
        />
      </Modal>

      <ModalForm<GenerateManagedKeyPayload>
        title={
          <Space>
            <Sparkles size={20} />
            生成新的密钥
          </Space>
        }
        open={generateOpen}
        initialValues={{ keyType: 'ED25519' }}
        modalProps={{
          destroyOnHidden: true,
          onCancel: () => setGenerateOpen(false),
        }}
        submitter={{
          searchConfig: { submitText: '生成并保存' },
          resetButtonProps: false,
        }}
        onFinish={async (values) => {
          await generateManagedKey(values, verificationToken);
          message.success('新密钥已生成并安全保存');
          setGenerateOpen(false);
          await loadKeys(verificationToken);
          return true;
        }}
      >
        <ProFormText
          name="label"
          label="名称"
          placeholder="例如：生产环境部署密钥"
          rules={[{ required: true, message: '请输入密钥名称' }]}
        />
        <ProFormRadio.Group
          name="keyType"
          label="密钥类型"
          radioType="button"
          options={[
            { label: 'ED25519', value: 'ED25519' },
            { label: 'ECDSA P-256', value: 'ECDSA' },
            { label: 'RSA 4096', value: 'RSA' },
          ]}
          rules={[{ required: true, message: '请选择密钥类型' }]}
        />
        <ProFormText.Password
          name="passphrase"
          label="私钥口令"
          placeholder="可选，至少 8 个字符"
          tooltip="口令只用于加密生成的私钥，系统不会单独保存"
          rules={[{ min: 8, message: '私钥口令至少需要 8 个字符' }]}
        />
        <Typography.Paragraph type="secondary">
          生成操作在服务器端完成，私钥会立即加密保存，页面只展示生成结果。
        </Typography.Paragraph>
      </ModalForm>

      <Drawer
        title={editingKey ? '编辑密钥' : '新建密钥'}
        width={520}
        open={drawerOpen}
        destroyOnHidden
        onClose={() => {
          setDrawerOpen(false);
          setEditingKey(undefined);
        }}
        extra={
          editingKey ? (
            <Popconfirm
              title="确定删除这个密钥吗？"
              description="删除后无法恢复。"
              onConfirm={async () => {
                await deleteManagedKey(editingKey.id, verificationToken);
                message.success('密钥已删除');
                setDrawerOpen(false);
                setEditingKey(undefined);
                await loadKeys(verificationToken);
              }}
            >
              <Button danger type="text" icon={<Trash2 size={16} />}>
                删除
              </Button>
            </Popconfirm>
          ) : null
        }
      >
        <Spin spinning={detailLoading}>
          <ProForm<ManagedKeyPayload>
            form={form}
            submitter={{
              searchConfig: {
                submitText: editingKey ? '保存修改' : '保存密钥',
              },
              resetButtonProps: false,
            }}
            onFinish={async (values) => {
              if (editingKey) {
                await updateManagedKey(
                  editingKey.id,
                  values,
                  verificationToken,
                );
                message.success('密钥已更新');
              } else {
                await createManagedKey(values, verificationToken);
                message.success('密钥已创建');
              }
              setDrawerOpen(false);
              setEditingKey(undefined);
              await loadKeys(verificationToken);
              return true;
            }}
          >
            <ProFormText
              name="label"
              label="名称"
              placeholder="例如：生产环境堡垒机"
              rules={[{ required: true, message: '请输入密钥名称' }]}
            />
            <ProFormSelect
              name="keyType"
              label="密钥类型"
              options={keyTypeOptions}
              rules={[{ required: true, message: '请选择密钥类型' }]}
            />
            <ProFormText name="description" label="备注" />
            <ProFormTextArea
              name="privateKey"
              label="私钥"
              fieldProps={{ rows: 8 }}
              tooltip={editingKey ? '保留原内容或粘贴新私钥' : undefined}
              rules={
                editingKey ? [] : [{ required: true, message: '请输入私钥' }]
              }
            />
            <Upload
              maxCount={1}
              showUploadList={false}
              beforeUpload={(file) => {
                const reader = new FileReader();
                reader.onload = () =>
                  form.setFieldValue('privateKey', String(reader.result || ''));
                reader.readAsText(file);
                return false;
              }}
            >
              <Button icon={<UploadIcon size={15} />}>从密钥文件导入</Button>
            </Upload>
            <ProFormTextArea
              name="publicKey"
              label="公钥"
              fieldProps={{ rows: 4 }}
            />
            <ProFormTextArea
              name="certificate"
              label="证书"
              fieldProps={{ rows: 4 }}
            />
          </ProForm>
        </Spin>
      </Drawer>
    </PageContainer>
  );
};

export default KeyManagementPage;
