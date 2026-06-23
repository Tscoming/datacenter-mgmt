import type { ActionType, ProColumns } from '@ant-design/pro-components';
import {
  ModalForm,
  PageContainer,
  ProFormSelect,
  ProFormText,
  ProTable,
} from '@ant-design/pro-components';
import { Button, message, Popconfirm, Space, Tag } from 'antd';
import { Edit3, Plus, Trash2, UserCog } from 'lucide-react';
import { useRef, useState } from 'react';
import {
  createUser,
  deleteUser,
  getUsers,
  updateUser,
} from '@/services/system/user';

const roleOptions = [
  { value: 'admin', label: '管理员' },
  { value: 'user', label: '普通用户' },
];

const statusOptions = [
  { value: 'active', label: '启用' },
  { value: 'disabled', label: '禁用' },
];

const roleText: Record<string, string> = {
  admin: '管理员',
  user: '普通用户',
};

const statusColor: Record<string, string> = {
  active: 'success',
  disabled: 'default',
};

const statusText: Record<string, string> = {
  active: '启用',
  disabled: '禁用',
};

const UserManagementPage: React.FC = () => {
  const actionRef = useRef<ActionType>(null);
  const [createOpen, setCreateOpen] = useState(false);
  const [editOpen, setEditOpen] = useState(false);
  const [currentUser, setCurrentUser] = useState<API.ManagedUser>();

  const columns: ProColumns<API.ManagedUser>[] = [
    {
      title: '用户',
      dataIndex: 'keyword',
      render: (_, record) => (
        <Space>
          <UserCog size={16} />
          <Space direction="vertical" size={0}>
            <span style={{ fontWeight: 500 }}>{record.name}</span>
            <span style={{ color: '#8c8c8c', fontSize: 12 }}>
              {record.username}
            </span>
          </Space>
        </Space>
      ),
    },
    {
      title: '邮箱',
      dataIndex: 'email',
      copyable: true,
      ellipsis: true,
    },
    {
      title: '手机',
      dataIndex: 'phone',
      search: false,
      width: 130,
      renderText: (value) => value || '-',
    },
    {
      title: '部门',
      dataIndex: 'department',
      search: false,
      width: 150,
      ellipsis: true,
      renderText: (value) => value || '-',
    },
    {
      title: '角色',
      dataIndex: 'role',
      width: 110,
      valueType: 'select',
      fieldProps: { options: roleOptions },
      render: (_, record) => (
        <Tag color={record.role === 'admin' ? 'blue' : 'green'}>
          {roleText[record.role] || record.role}
        </Tag>
      ),
    },
    {
      title: '状态',
      dataIndex: 'status',
      width: 100,
      valueType: 'select',
      fieldProps: { options: statusOptions },
      render: (_, record) => (
        <Tag color={statusColor[record.status]}>
          {statusText[record.status] || record.status}
        </Tag>
      ),
    },
    {
      title: '最近登录',
      dataIndex: 'lastLoginAt',
      valueType: 'dateTime',
      search: false,
      width: 170,
      renderText: (value) => value || '-',
    },
    {
      title: '创建时间',
      dataIndex: 'createdAt',
      valueType: 'dateTime',
      search: false,
      width: 170,
    },
    {
      title: '操作',
      valueType: 'option',
      width: 150,
      fixed: 'right',
      render: (_, record) => [
        <Button
          key="edit"
          type="link"
          size="small"
          icon={<Edit3 size={14} />}
          onClick={() => {
            setCurrentUser(record);
            setEditOpen(true);
          }}
        >
          编辑
        </Button>,
        <Popconfirm
          key="delete"
          title="确定要删除这个用户吗？"
          onConfirm={async () => {
            const res = await deleteUser(record.id);
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

  const userForm = (mode: 'create' | 'edit') => (
    <>
      <ProFormText
        name="username"
        label="用户名"
        disabled={mode === 'edit'}
        rules={[
          { required: true, message: '请输入用户名' },
          {
            pattern: /^[a-zA-Z0-9_.-]{3,32}$/,
            message: '用户名只能包含字母、数字、下划线、点和短横线，长度 3-32 位',
          },
        ]}
      />
      <ProFormText
        name="name"
        label="姓名"
        rules={[{ required: true, message: '请输入姓名' }]}
      />
      <ProFormText
        name="email"
        label="邮箱"
        rules={[
          { required: true, message: '请输入邮箱' },
          { type: 'email', message: '邮箱格式不正确' },
        ]}
      />
      <ProFormText.Password
        name="password"
        label={mode === 'create' ? '密码' : '重置密码'}
        tooltip={mode === 'edit' ? '留空表示不修改密码' : undefined}
        rules={
          mode === 'create'
            ? [
                { required: true, message: '请输入密码' },
                { min: 6, message: '密码至少需要 6 位' },
              ]
            : [{ min: 6, message: '密码至少需要 6 位' }]
        }
      />
      <ProFormSelect
        name="role"
        label="角色"
        options={roleOptions}
        rules={[{ required: true, message: '请选择角色' }]}
      />
      <ProFormSelect
        name="status"
        label="状态"
        options={statusOptions}
        rules={[{ required: true, message: '请选择状态' }]}
      />
      <ProFormText name="phone" label="手机" />
      <ProFormText name="department" label="部门" />
      <ProFormText name="title" label="职务" />
      <ProFormText name="avatar" label="头像 URL" />
    </>
  );

  return (
    <PageContainer>
      <ProTable<API.ManagedUser>
        actionRef={actionRef}
        rowKey="id"
        columns={columns}
        request={async (params) => {
          const res = await getUsers({
            current: params.current,
            pageSize: params.pageSize,
            keyword: params.keyword as string,
            role: params.role as string,
            status: params.status as string,
          });
          return {
            data: res.data,
            total: res.total,
            success: res.success,
          };
        }}
        search={{ labelWidth: 90 }}
        pagination={{ defaultPageSize: 10 }}
        scroll={{ x: 1200 }}
        toolBarRender={() => [
          <Button
            key="create"
            type="primary"
            icon={<Plus size={16} />}
            onClick={() => setCreateOpen(true)}
          >
            新建用户
          </Button>,
        ]}
      />

      <ModalForm<API.ManagedUserPayload>
        title="新建用户"
        open={createOpen}
        modalProps={{
          destroyOnHidden: true,
          onCancel: () => setCreateOpen(false),
        }}
        initialValues={{ role: 'user', status: 'active' }}
        onFinish={async (values) => {
          const res = await createUser(values);
          if (res.success) {
            message.success('创建成功');
            setCreateOpen(false);
            actionRef.current?.reload();
            return true;
          }
          return false;
        }}
      >
        {userForm('create')}
      </ModalForm>

      <ModalForm<API.ManagedUserPayload>
        title="编辑用户"
        open={editOpen}
        modalProps={{
          destroyOnHidden: true,
          onCancel: () => {
            setEditOpen(false);
            setCurrentUser(undefined);
          },
        }}
        initialValues={currentUser}
        onFinish={async (values) => {
          if (!currentUser) return false;
          const payload = { ...values };
          if (!payload.password) delete payload.password;
          const res = await updateUser(currentUser.id, payload);
          if (res.success) {
            message.success('保存成功');
            setEditOpen(false);
            setCurrentUser(undefined);
            actionRef.current?.reload();
            return true;
          }
          return false;
        }}
      >
        {userForm('edit')}
      </ModalForm>
    </PageContainer>
  );
};

export default UserManagementPage;
