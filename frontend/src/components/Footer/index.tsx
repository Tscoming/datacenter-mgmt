import { DefaultFooter } from '@ant-design/pro-components';
import React from 'react';

const Footer: React.FC = () => {
  return (
    <DefaultFooter
      style={{
        background: 'none',
      }}
      copyright="Powered by Dell Profession Service"
      links={[
        {
          key: 'iColor.Design',
          title: 'Datacenter Digital Twin',
          href: 'https://en.wikipedia.org/wiki/Digital_twin',
          blankTarget: true,
        },
      ]}
    />
  );
};

export default Footer;
