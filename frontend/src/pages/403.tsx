import { history, useIntl } from '@umijs/max';
import { Button, Card, Result } from 'antd';
import React from 'react';

const ForbiddenPage: React.FC = () => (
  <Card variant="borderless">
    <Result
      status="403"
      title="403"
      subTitle={useIntl().formatMessage({
        id: 'pages.403.subTitle',
        defaultMessage: '抱歉，你无权访问该页面。',
      })}
      extra={
        <Button type="primary" onClick={() => history.push('/')}>
          {useIntl().formatMessage({
            id: 'pages.403.buttonText',
            defaultMessage: '返回首页',
          })}
        </Button>
      }
    />
  </Card>
);

export default ForbiddenPage;
