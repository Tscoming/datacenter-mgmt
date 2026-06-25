import {
  AlipayCircleOutlined,
  ApiOutlined,
  CloudServerOutlined,
  DatabaseOutlined,
  LockOutlined,
  MobileOutlined,
  SafetyCertificateOutlined,
  TaobaoCircleOutlined,
  UserOutlined,
  WeiboCircleOutlined,
} from '@ant-design/icons';
import {
  LoginForm,
  ProFormCaptcha,
  ProFormCheckbox,
  ProFormText,
} from '@ant-design/pro-components';
import {
  FormattedMessage,
  Helmet,
  SelectLang,
  useIntl,
  useModel,
} from '@umijs/max';
import { Alert, App, Tabs } from 'antd';
import { createStyles } from 'antd-style';
import React, { useEffect, useRef, useState } from 'react';
import { flushSync } from 'react-dom';
import { Footer } from '@/components';
import { login } from '@/services/ant-design-pro/api';
import { getFakeCaptcha } from '@/services/ant-design-pro/login';
import { setSession } from '@/utils/session';
import Settings from '../../../../config/defaultSettings';

const useStyles = createStyles(({ token }) => {
  return {
    action: {
      marginLeft: '8px',
      color: 'rgba(0, 0, 0, 0.2)',
      fontSize: '24px',
      verticalAlign: 'middle',
      cursor: 'pointer',
      transition: 'color 0.3s',
      '&:hover': {
        color: token.colorPrimaryActive,
      },
    },
    lang: {
      width: 42,
      height: 42,
      lineHeight: '42px',
      position: 'fixed',
      top: 16,
      right: 16,
      zIndex: 10,
      borderRadius: token.borderRadius,
      ':hover': {
        backgroundColor: 'rgba(255, 255, 255, 0.14)',
      },
    },
    container: {
      position: 'relative',
      display: 'flex',
      flexDirection: 'column',
      minHeight: '100vh',
      height: '100vh',
      overflow: 'auto',
      background:
        'linear-gradient(135deg, #061321 0%, #0a2230 42%, #142d34 100%)',
      color: '#fff',
      '&::before': {
        position: 'absolute',
        inset: 0,
        pointerEvents: 'none',
        content: '""',
        backgroundImage:
          'linear-gradient(rgba(72, 211, 255, 0.08) 1px, transparent 1px), linear-gradient(90deg, rgba(72, 211, 255, 0.08) 1px, transparent 1px)',
        backgroundSize: '44px 44px',
        maskImage:
          'linear-gradient(90deg, rgba(0, 0, 0, 0.88), rgba(0, 0, 0, 0.18))',
      },
      '&::after': {
        position: 'absolute',
        inset: 0,
        pointerEvents: 'none',
        content: '""',
        background:
          'radial-gradient(circle at 16% 24%, rgba(16, 185, 129, 0.24), transparent 26%), radial-gradient(circle at 80% 12%, rgba(45, 212, 191, 0.18), transparent 24%), linear-gradient(180deg, transparent 0%, rgba(6, 19, 33, 0.62) 100%)',
      },
    },
    vantaBackground: {
      position: 'absolute',
      inset: 0,
      zIndex: 0,
      overflow: 'hidden',
      background:
        'radial-gradient(circle at 18% 22%, rgba(34, 211, 238, 0.18), transparent 28%), #061321',
      '& canvas': {
        opacity: 0.76,
      },
    },
    loginShell: {
      position: 'relative',
      zIndex: 1,
      display: 'grid',
      gridTemplateColumns: 'minmax(0, 1fr) 500px',
      alignItems: 'center',
      flex: 1,
      gap: 48,
      width: 'min(1180px, calc(100% - 64px))',
      margin: '0 auto',
      padding: '48px 0 32px',
      '@media (max-width: 960px)': {
        gridTemplateColumns: '1fr',
        width: 'min(620px, calc(100% - 32px))',
        gap: 28,
        paddingTop: 72,
      },
    },
    hero: {
      display: 'flex',
      flexDirection: 'column',
      gap: 28,
      '@media (max-width: 960px)': {
        gap: 20,
      },
    },
    eyebrow: {
      display: 'inline-flex',
      alignItems: 'center',
      alignSelf: 'flex-start',
      gap: 8,
      padding: '6px 10px',
      border: '1px solid rgba(103, 232, 249, 0.3)',
      borderRadius: 999,
      color: '#a7f3d0',
      fontSize: 13,
      background: 'rgba(6, 95, 70, 0.18)',
    },
    heroTitle: {
      maxWidth: 680,
      margin: 0,
      color: '#f8fafc',
      fontSize: 48,
      fontWeight: 700,
      lineHeight: 1.14,
      '@media (max-width: 720px)': {
        fontSize: 34,
      },
    },
    heroText: {
      maxWidth: 600,
      margin: 0,
      color: 'rgba(226, 232, 240, 0.78)',
      fontSize: 17,
      lineHeight: 1.8,
    },
    twinPanel: {
      display: 'grid',
      gridTemplateColumns: 'minmax(260px, 1fr) 190px',
      gap: 18,
      alignItems: 'stretch',
      maxWidth: 720,
      '@media (max-width: 720px)': {
        gridTemplateColumns: '1fr',
      },
    },
    twinMap: {
      position: 'relative',
      minHeight: 300,
      overflow: 'hidden',
      border: '1px solid rgba(148, 163, 184, 0.28)',
      borderRadius: 8,
      background:
        'linear-gradient(145deg, rgba(15, 23, 42, 0.72), rgba(15, 118, 110, 0.2))',
      boxShadow: '0 24px 80px rgba(0, 0, 0, 0.28)',
      '&::before': {
        position: 'absolute',
        inset: 18,
        content: '""',
        border: '1px solid rgba(45, 212, 191, 0.24)',
        borderRadius: 6,
      },
    },
    gridFloor: {
      position: 'absolute',
      right: 24,
      bottom: 22,
      left: 24,
      height: 120,
      transform: 'skewX(-20deg)',
      transformOrigin: 'bottom',
      backgroundImage:
        'linear-gradient(rgba(94, 234, 212, 0.24) 1px, transparent 1px), linear-gradient(90deg, rgba(94, 234, 212, 0.24) 1px, transparent 1px)',
      backgroundSize: '28px 24px',
      borderBottom: '1px solid rgba(94, 234, 212, 0.42)',
    },
    rack: {
      position: 'absolute',
      bottom: 72,
      width: 50,
      height: 126,
      border: '1px solid rgba(125, 211, 252, 0.42)',
      borderRadius: 4,
      background:
        'repeating-linear-gradient(180deg, rgba(15, 23, 42, 0.92) 0 12px, rgba(20, 184, 166, 0.2) 12px 16px)',
      boxShadow: '0 0 26px rgba(45, 212, 191, 0.22)',
    },
    rackOne: {
      left: '16%',
    },
    rackTwo: {
      left: '34%',
      height: 152,
    },
    rackThree: {
      left: '52%',
      height: 136,
    },
    rackFour: {
      left: '70%',
      height: 166,
    },
    dataLink: {
      position: 'absolute',
      top: 64,
      right: 54,
      left: 54,
      height: 118,
      borderTop: '1px solid rgba(103, 232, 249, 0.45)',
      borderRight: '1px solid rgba(103, 232, 249, 0.25)',
      borderLeft: '1px solid rgba(103, 232, 249, 0.25)',
      borderRadius: '80px 80px 0 0',
    },
    node: {
      position: 'absolute',
      width: 10,
      height: 10,
      borderRadius: '50%',
      background: '#67e8f9',
      boxShadow: '0 0 18px #67e8f9',
    },
    nodeOne: {
      top: 58,
      left: '19%',
    },
    nodeTwo: {
      top: 34,
      left: '49%',
    },
    nodeThree: {
      top: 82,
      right: '19%',
    },
    layerList: {
      display: 'grid',
      gap: 12,
    },
    layerItem: {
      display: 'grid',
      gridTemplateColumns: '32px 1fr',
      gap: 10,
      alignItems: 'center',
      minHeight: 72,
      padding: 12,
      border: '1px solid rgba(148, 163, 184, 0.24)',
      borderRadius: 8,
      background: 'rgba(15, 23, 42, 0.48)',
    },
    layerIcon: {
      display: 'grid',
      placeItems: 'center',
      width: 32,
      height: 32,
      borderRadius: 6,
      color: '#67e8f9',
      background: 'rgba(8, 145, 178, 0.18)',
    },
    layerTitle: {
      margin: 0,
      color: '#f8fafc',
      fontSize: 14,
      fontWeight: 600,
    },
    layerDesc: {
      margin: '4px 0 0',
      color: 'rgba(203, 213, 225, 0.68)',
      fontSize: 12,
      lineHeight: 1.5,
    },
    metrics: {
      display: 'grid',
      gridTemplateColumns: 'repeat(3, minmax(0, 1fr))',
      gap: 12,
      maxWidth: 620,
      '@media (max-width: 560px)': {
        gridTemplateColumns: '1fr',
      },
    },
    metricItem: {
      padding: '14px 16px',
      border: '1px solid rgba(148, 163, 184, 0.22)',
      borderRadius: 8,
      background: 'rgba(15, 23, 42, 0.44)',
    },
    metricValue: {
      margin: 0,
      color: '#f8fafc',
      fontSize: 24,
      fontWeight: 700,
      lineHeight: 1.2,
    },
    metricLabel: {
      margin: '6px 0 0',
      color: 'rgba(203, 213, 225, 0.7)',
      fontSize: 12,
    },
    loginCard: {
      boxSizing: 'border-box',
      width: '100%',
      padding: '28px 28px 18px',
      border: '1px solid rgba(226, 232, 240, 0.2)',
      borderRadius: 8,
      background: 'rgba(255, 255, 255, 0.94)',
      boxShadow: '0 24px 70px rgba(0, 0, 0, 0.32)',
      backdropFilter: 'blur(18px)',
      '& .ant-pro-form-login-logo': {
        width: 44,
        height: 44,
      },
      '& .ant-pro-form-login-title': {
        color: '#0f172a',
        fontSize: 25,
        lineHeight: 1.3,
      },
      '& .ant-pro-form-login-desc': {
        color: '#475569',
        lineHeight: 1.6,
      },
      '& .ant-tabs-tab': {
        fontWeight: 600,
      },
      '& .ant-pro-form-login-container': {
        padding: 0,
        width: '100%',
      },
      '@media (max-width: 960px)': {
        order: -1,
        padding: '24px 20px 14px',
      },
    },
  };
});

const metrics = [
  { label: '资产映射', value: '1:1' },
  { label: '环境联动', value: '24h' },
  { label: '告警闭环', value: '实时' },
];

const twinLayers = [
  {
    icon: <CloudServerOutlined />,
    title: '机房空间',
    desc: '承载楼层、机柜、设备的三维映射',
  },
  {
    icon: <DatabaseOutlined />,
    title: '运行数据',
    desc: '融合容量、能耗、温湿度与告警',
  },
  {
    icon: <SafetyCertificateOutlined />,
    title: '运维决策',
    desc: '面向巡检、定位和处置的统一入口',
  },
];

const _ActionIcons = () => {
  const { styles } = useStyles();

  return (
    <>
      <AlipayCircleOutlined
        key="AlipayCircleOutlined"
        className={styles.action}
      />
      <TaobaoCircleOutlined
        key="TaobaoCircleOutlined"
        className={styles.action}
      />
      <WeiboCircleOutlined
        key="WeiboCircleOutlined"
        className={styles.action}
      />
    </>
  );
};

const Lang = () => {
  const { styles } = useStyles();

  return (
    <div className={styles.lang} data-lang>
      {SelectLang && <SelectLang />}
    </div>
  );
};

const LoginMessage: React.FC<{
  content: string;
}> = ({ content }) => {
  return (
    <Alert
      style={{
        marginBottom: 24,
      }}
      message={content}
      type="error"
      showIcon
    />
  );
};

const Login: React.FC = () => {
  const vantaRef = useRef<HTMLDivElement>(null);
  const [userLoginState, setUserLoginState] = useState<API.LoginResult>({});
  const [type, setType] = useState<string>('account');
  const { initialState, setInitialState } = useModel('@@initialState');
  const { styles } = useStyles();
  const { message } = App.useApp();
  const intl = useIntl();

  useEffect(() => {
    let effect:
      | {
          destroy: () => void;
        }
      | undefined;
    let mounted = true;

    const initVanta = async () => {
      if (!vantaRef.current) {
        return;
      }

      const [THREE, vantaNet] = await Promise.all([
        import('three'),
        import('vanta/dist/vanta.net.min'),
      ]);

      if (!mounted || !vantaRef.current) {
        return;
      }

      const createNet = vantaNet.default ?? vantaNet;
      effect = createNet({
        el: vantaRef.current,
        THREE,
        mouseControls: true,
        touchControls: true,
        gyroControls: false,
        minHeight: 200,
        minWidth: 200,
        scale: 1,
        scaleMobile: 0.72,
        color: 0x67e8f9,
        backgroundColor: 0x061321,
        backgroundAlpha: 0,
        points: 13,
        maxDistance: 24,
        spacing: 18,
        showDots: true,
      });
    };

    initVanta();

    return () => {
      mounted = false;
      effect?.destroy();
    };
  }, []);

  const fetchUserInfo = async () => {
    const userInfo = await initialState?.fetchUserInfo?.();
    if (userInfo) {
      flushSync(() => {
        setInitialState((s) => ({
          ...s,
          currentUser: userInfo,
        }));
      });
    }
  };

  const handleSubmit = async (values: API.LoginParams) => {
    try {
      // 登录
      const msg = await login({ ...values, type });
      if (msg.status === 'ok') {
        const token = (msg as any).token;
        const refreshToken = (msg as any).refreshToken;
        const expiresAt = (msg as any).expiresAt;
        if (token && refreshToken && expiresAt) {
          setSession({ token, refreshToken, expiresAt });
        } else if (token) {
          localStorage.setItem('token', token);
        }
        const defaultLoginSuccessMessage = intl.formatMessage({
          id: 'pages.login.success',
          defaultMessage: '登录成功！',
        });
        message.success(defaultLoginSuccessMessage);
        await fetchUserInfo();
        const urlParams = new URL(window.location.href).searchParams;
        window.location.href = urlParams.get('redirect') || '/';
        return;
      }
      console.log(msg);
      // 如果失败去设置用户错误信息
      setUserLoginState(msg);
    } catch (error) {
      const defaultLoginFailureMessage = intl.formatMessage({
        id: 'pages.login.failure',
        defaultMessage: '登录失败，请重试！',
      });
      console.log(error);
      message.error(defaultLoginFailureMessage);
    }
  };
  const { status, type: loginType } = userLoginState;

  return (
    <div className={styles.container}>
      <div ref={vantaRef} className={styles.vantaBackground} />
      <Helmet>
        <title>
          {intl.formatMessage({
            id: 'menu.login',
            defaultMessage: '登录页',
          })}
          {Settings.title && ` - ${Settings.title}`}
        </title>
      </Helmet>
      <Lang />
      <main className={styles.loginShell}>
        <section className={styles.hero}>
          <div>
            <div className={styles.eyebrow}>
              <ApiOutlined />
              Digital Twin Operations
            </div>
            <h1 className={styles.heroTitle}>
              以数字孪生连接资产、环境与运维决策
            </h1>
            <p className={styles.heroText}>
              面向数据中心基础设施的统一入口，将三维空间、实时数据和告警流程映射到同一运维视图。
            </p>
          </div>
          <div className={styles.twinPanel} aria-hidden="true">
            <div className={styles.twinMap}>
              <div className={styles.dataLink} />
              <div className={`${styles.node} ${styles.nodeOne}`} />
              <div className={`${styles.node} ${styles.nodeTwo}`} />
              <div className={`${styles.node} ${styles.nodeThree}`} />
              <div className={styles.gridFloor} />
              <div className={`${styles.rack} ${styles.rackOne}`} />
              <div className={`${styles.rack} ${styles.rackTwo}`} />
              <div className={`${styles.rack} ${styles.rackThree}`} />
              <div className={`${styles.rack} ${styles.rackFour}`} />
            </div>
            <div className={styles.layerList}>
              {twinLayers.map((item) => (
                <div className={styles.layerItem} key={item.title}>
                  <span className={styles.layerIcon}>{item.icon}</span>
                  <div>
                    <p className={styles.layerTitle}>{item.title}</p>
                    <p className={styles.layerDesc}>{item.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
          <div className={styles.metrics}>
            {metrics.map((item) => (
              <div className={styles.metricItem} key={item.label}>
                <p className={styles.metricValue}>{item.value}</p>
                <p className={styles.metricLabel}>{item.label}</p>
              </div>
            ))}
          </div>
        </section>
        <section className={styles.loginCard}>
          <LoginForm
            contentStyle={{
              minWidth: 280,
              maxWidth: '100%',
            }}
            logo={<img alt="logo" src="/logo.svg" />}
            title="基础设施数字孪生系统"
            subTitle={intl.formatMessage({
              id: 'pages.layouts.userLayout.title',
            })}
            initialValues={{
              autoLogin: true,
            }}
            actions={
              [
                // <FormattedMessage
                //   key="loginWith"
                //   id="pages.login.loginWith"
                //   defaultMessage="其他登录方式"
                // />,
                // <ActionIcons key="icons" />,
              ]
            }
            onFinish={async (values) => {
              await handleSubmit(values as API.LoginParams);
            }}
          >
            <Tabs
              activeKey={type}
              onChange={setType}
              centered
              items={[
                {
                  key: 'account',
                  label: intl.formatMessage({
                    id: 'pages.login.accountLogin.tab',
                    defaultMessage: '账户密码登录',
                  }),
                },
                // {
                //   key: 'mobile',
                //   label: intl.formatMessage({
                //     id: 'pages.login.phoneLogin.tab',
                //     defaultMessage: '手机号登录',
                //   }),
                // },
              ]}
            />

            {status === 'error' && loginType === 'account' && (
              <LoginMessage
                content={intl.formatMessage({
                  id: 'pages.login.accountLogin.errorMessage',
                  defaultMessage: '账户或密码错误(admin/ant.design)',
                })}
              />
            )}
            {type === 'account' && (
              <>
                <ProFormText
                  name="username"
                  fieldProps={{
                    size: 'large',
                    prefix: <UserOutlined />,
                  }}
                  placeholder={intl.formatMessage({
                    id: 'pages.login.username.placeholder',
                    defaultMessage: '用户名: admin or user',
                  })}
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.username.required"
                          defaultMessage="请输入用户名!"
                        />
                      ),
                    },
                  ]}
                />
                <ProFormText.Password
                  name="password"
                  fieldProps={{
                    size: 'large',
                    prefix: <LockOutlined />,
                  }}
                  placeholder={intl.formatMessage({
                    id: 'pages.login.password.placeholder',
                    defaultMessage: '密码',
                  })}
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.password.required"
                          defaultMessage="请输入密码！"
                        />
                      ),
                    },
                  ]}
                />
              </>
            )}

            {status === 'error' && loginType === 'mobile' && (
              <LoginMessage content="验证码错误" />
            )}
            {type === 'mobile' && (
              <>
                <ProFormText
                  fieldProps={{
                    size: 'large',
                    prefix: <MobileOutlined />,
                  }}
                  name="mobile"
                  placeholder={intl.formatMessage({
                    id: 'pages.login.phoneNumber.placeholder',
                    defaultMessage: '手机号',
                  })}
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.phoneNumber.required"
                          defaultMessage="请输入手机号！"
                        />
                      ),
                    },
                    {
                      pattern: /^1\d{10}$/,
                      message: (
                        <FormattedMessage
                          id="pages.login.phoneNumber.invalid"
                          defaultMessage="手机号格式错误！"
                        />
                      ),
                    },
                  ]}
                />
                <ProFormCaptcha
                  fieldProps={{
                    size: 'large',
                    prefix: <LockOutlined />,
                  }}
                  captchaProps={{
                    size: 'large',
                  }}
                  placeholder={intl.formatMessage({
                    id: 'pages.login.captcha.placeholder',
                    defaultMessage: '请输入验证码',
                  })}
                  captchaTextRender={(timing, count) => {
                    if (timing) {
                      return `${count} ${intl.formatMessage({
                        id: 'pages.getCaptchaSecondText',
                        defaultMessage: '获取验证码',
                      })}`;
                    }
                    return intl.formatMessage({
                      id: 'pages.login.phoneLogin.getVerificationCode',
                      defaultMessage: '获取验证码',
                    });
                  }}
                  name="captcha"
                  rules={[
                    {
                      required: true,
                      message: (
                        <FormattedMessage
                          id="pages.login.captcha.required"
                          defaultMessage="请输入验证码！"
                        />
                      ),
                    },
                  ]}
                  onGetCaptcha={async (phone) => {
                    const result = await getFakeCaptcha({
                      phone,
                    });
                    if (!result) {
                      return;
                    }
                    message.success('获取验证码成功！验证码为：1234');
                  }}
                />
              </>
            )}
            <div
              style={{
                marginBottom: 24,
              }}
            >
              <ProFormCheckbox noStyle name="autoLogin">
                <FormattedMessage
                  id="pages.login.rememberMe"
                  defaultMessage="自动登录"
                />
              </ProFormCheckbox>
              <a
                style={{
                  float: 'right',
                }}
              >
                <FormattedMessage
                  id="pages.login.forgotPassword"
                  defaultMessage="忘记密码"
                />
              </a>
            </div>
          </LoginForm>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default Login;
