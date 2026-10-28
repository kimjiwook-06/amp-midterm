const jsonServer = require('json-server');
const path = require('path');
const app = jsonServer.create();
app.use(jsonServer.defaults({readOnly:true}));
app.use(jsonServer.router(path.join(__dirname,'db.json')));
const port=Number(process.env.PORT || 3000);
app.listen(port,'0.0.0.0',()=>console.log(`Read-only json-server: http://localhost:${port}/items`));
