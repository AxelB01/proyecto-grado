const { createProxyMiddleware } = require('http-proxy-middleware');
// const { env } = require('process');

// const target = env.ASPNETCORE_HTTPS_PORT ? `https://localhost:${env.ASPNETCORE_HTTPS_PORT}` :
//  env.ASPNETCORE_URLS ? env.ASPNETCORE_URLS.split(';')[0] : 'http://localhost:41089';

const target = 'https://localhost:7204';

const context =  [
    "/api/auth",
    "/api/data",
    "/api/usuarios",
    "/api/solicitudes",
    "/api/familias",
    "/api/articulos",
    "/api/catalogos",
    "/api/proveedores",
    "/api/almacenes",
    "/api/configuraciones",
];

module.exports = function(app) {
  const appProxy = createProxyMiddleware(context, {
    target,
    secure: false,
    headers: {
      Connection: 'Keep-Alive'
    }
  });

  app.use(appProxy);
};
