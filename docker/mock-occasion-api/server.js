const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router();
const middlewares = jsonServer.defaults();

let mockData = require('./mockData');

const mocked = mockData();
const orders = mocked.orders;
const ordersWithIncludes = mocked.ordersWithIncludes;

server.get('/orders/:id', (req, res) => {
    let order = ordersWithIncludes.find((order) => {
        "use strict";

        return order.data[0].id === req.params.id;
    });

    res.jsonp({
        data: order.data[0],
        included: order.included
    });
});

// Add custom routes before JSON Server router
server.get('/orders', (req, res) => {
    let response = {};

    if (req.query.filter) {
        response = ordersWithIncludes.find((order) => {
            "use strict";

            return order.data[0].attributes.verification_code === req.query.filter.verification_code;
        });

    } else if (req.query.page) {
        let pageNum = parseInt(req.query.page.number);
        let numOrdersPerPage = parseInt(req.query.page.size);

        let startingIndex = (pageNum - 1) * numOrdersPerPage;
        let endingIndex = startingIndex + numOrdersPerPage;

        let lastPageNum = Math.ceil(orders.length / numOrdersPerPage);

        response.data = orders.slice(startingIndex, endingIndex);
        response.links = {
            'self': `https://www.occsn.com/api/v1/orders?page%5Bnumber%5D=${pageNum}&page%5Bsize%5D=${numOrdersPerPage}`,
            'next': `https://www.occsn.com/api/v1/orders?page%5Bnumber%5D=${pageNum + 1}&page%5Bsize%5D=${numOrdersPerPage}`,
            'last': `https://www.occsn.com/api/v1/orders?page%5Bnumber%5D=${lastPageNum}&page%5Bsize%5D=${numOrdersPerPage}`
        }
    }

    res.jsonp(response);
});

server.use(middlewares);
server.use(router);
server.listen(3000, () => {
    console.log('JSON Server is running')
});
