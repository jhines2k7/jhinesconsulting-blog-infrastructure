const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router();
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(jsonServer.bodyParser);

server.post('/contact', (req, res) => {
    res.status(200).jsonp({
        success: "The contact form was submitted successfully"
    })
});

server.use(router);
server.listen(3000, () => {
    console.log('Mock form submission service is running on port 3000')
});
