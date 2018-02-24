const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router();
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(jsonServer.bodyParser);

server.post('/contact', (req, res) => {
    if(req.body.email === '400error@gmail.com') {
        res.status(400).jsonp({
            error: "The server cannot or will not process the request due to a client error"
        })
    } else if(req.body.email === '500error@gmail.com') {
        res.status(500).jsonp({
            success: "The server has encountered an unexpected error and is incapable of performing the request"
        })
    } else {
        res.status(200).jsonp({
            success: "The contact form was submitted successfully"
        })
    }
});

server.use(router);
server.listen(3000, () => {
    console.log('Mock form submission service is running on port 3000')
});
