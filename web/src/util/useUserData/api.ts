import ky from 'ky';

export const AuthUrl = (() => {
  const { protocol, host } = window.location;

  // 让 kuriko 的开发环境可以跑起来，后续需要支持开发环境免登录
  if (host.startsWith('localhost:')) {
    return `${protocol}//localhost:8000`;
  }

  // 检查是否为 IP 地址 (任何以数字开头的 host 都视为 IP 地址)
  // 支持: 192.168.1.100, 5.200, 10.0.0.5:3000 等格式
  const hostWithoutPort = host.split(':')[0];
  const isIpAddress = /^\d/.test(hostWithoutPort);

  if (isIpAddress) {
    // IP 地址直接使用当前 host，不添加 auth. 前缀
    return `${protocol}//${host}`;
  }

  // 不考虑 a.co.uk 这种顶级域名
  //  n.novelia.cc => auth.novelia.cc
  //  test.com => auth.test.com
  const parts = host.split('.');
  const baseDomain = parts.length > 2 ? parts.slice(-2).join('.') : host;
  return `${protocol}//auth.${baseDomain}`;
})();

const client = ky.create({
  prefixUrl: AuthUrl + '/api/v1',
  credentials: 'include',
});

export const AuthApi = {
  refresh: (app: string) =>
    client.post(`auth/refresh`, { searchParams: { app } }).text(),
  logout: () => client.post(`auth/logout`).text(),
};
