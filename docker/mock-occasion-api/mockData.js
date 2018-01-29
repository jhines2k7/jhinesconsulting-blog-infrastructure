let faker = require('faker');
let padStart = require('string.prototype.padstart');

padStart.shim();

const NUM_ORDERS = parseInt(process.env.NUM_ORDERS);
const NUM_OCCURRENCES = parseInt(process.env.NUM_OCCURRENCES);
const NUM_CUSTOMERS = parseInt(process.env.NUM_CUSTOMERS);
const NUM_QUESTIONS = parseInt(process.env.NUM_QUESTIONS);
const NUM_ANSWERS = parseInt(process.env.NUM_ANSWERS);

function generateOccurence() {
    let date = randomDate(new Date(2014, 0, 1), new Date());
    let occurrenceId = randomString(8, '0123456789abcdefghijklmnopqrstuvwxyz');

    let durationTimes = [120, 60];
    let duration = durationTimes[Math.floor(Math.random() * 2)];

    let year = Math.floor(Math.random() * 4) + 2014;
    let month = Math.floor(Math.random() * 12) + 1;
    let day = Math.floor(Math.random() * 28) + 1;
    let startHour = Math.floor(Math.random() * 9) + 12;
    let endHour = startHour + duration / 60;

    let minuteTimes = [0, 30];
    let minute = minuteTimes[Math.floor(Math.random() * 2)];

    return {
        "id": occurrenceId,
        "type": "occurrences",
        "attributes": {
            "record_id": Math.floor(Math.random() * 899999) + 100000,
            "closes_at": null,
            "created_at": date,
            "duration": duration,
            "ends_at": `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}T${endHour}:${minute}:00.000-04:00`,
            "is_active": true,
            "schedule_id": Math.floor(Math.random() * 199999) + 100000,
            "starts_at": `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}T${startHour}:${minute}:00.000-04:00`,
            "time_slot_id": `2017${randomString(14, '0123456789')}`,
            "updated_at": date
        },
        "relationships": {
            "product": {}
        }
    }
}

function generateAnswers() {
    "use strict";

    let answers = [];

    for (let i = 0; i < NUM_ANSWERS; i++) {
        answers.push(faker.hacker.phrase());
    }

    return answers;
}

function generateQuestions() {
    "use strict";

    let questions = [];

    for (let i = 0; i < NUM_QUESTIONS; i++) {
        questions.push(faker.hacker.phrase());
    }

    return questions;
}

function generateAttributeValue(question, answer) {
    let date = randomDate(new Date(2014, 0, 1), new Date());
    let attributeId = randomString(8, '0123456789abcdefghijklmnopqrstuvwxyz');

    return {
        "id": attributeId,
        "type": "attribute_values",
        "attributes": {
            "record_id": Math.floor(Math.random() * 8999999) + 1000000,
            "attribute_title": question,
            "created_at": date,
            "updated_at": date,
            "value": answer
        },
        "relationships": {
            "attr": {},
            "attribute_option": {},
            "order": {}
        }
    }
}

function generateCustomer(id) {
    let customerId = randomString(8, '0123456789abcdefghijklmnopqrstuvwxyz');

    let date = randomDate(new Date(2014, 0, 1), new Date());

    return {
        'id': customerId,
        'type': 'customers',
        'attributes': {
            // 'record_id': Math.floor(Math.random() * 89999) + 10000,
            'record_id': id,
            'address': faker.address.streetAddress(),
            'city': faker.address.city(),
            'created_at': date,
            'email': faker.internet.email().toLowerCase(),
            'first_name': faker.name.firstName(),
            'last_name': faker.name.lastName(),
            'phone': faker.phone.phoneNumberFormat(),
            'updated_at': date,
            'zip': faker.address.zipCode()
        },
        relationships: {
            "state": {
                "links": {
                    "self": `https://www.occsn.com/api/v1/customers/${customerId}/relationships/state`,
                    "related": `https://www.occsn.com/api/v1/customers/${customerId}/state`
                }
            },
            "comments": {
                "links": {
                    "self": `https://www.occsn.com/api/v1/customers/${customerId}/relationships/comments`,
                    "related": `https://www.occsn.com/api/v1/customers/${customerId}/comments`
                }
            },
            "gift_cards": {
                "links": {
                    "self": `https://www.occsn.com/api/v1/customers/${customerId}/relationships/gift_cards`,
                    "related": `https://www.occsn.com/api/v1/customers/${customerId}/gift_cards`
                }
            },
            "retained_payment_methods": {
                "links": {
                    "self": `https://www.occsn.com/api/v1/customers/${customerId}/relationships/retained_payment_methods`,
                    "related": `https://www.occsn.com/api/v1/customers/${customerId}/retained_payment_methods`
                }
            },
            "orders": {
                "links": {
                    "self": `https://www.occsn.com/api/v1/customers/${customerId}/relationships/orders`,
                    "related": `https://www.occsn.com/api/v1/customers/${customerId}/orders`
                }
            }
        },
        links: {
            self: `https://www.occsn.com/api/v1/customers/${customerId}`
        }
    }
}

function generateOrder(customer, id) {
    let verificationCode = randomString(6, '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');

    let orderId = randomString(8, '0123456789abcdefghijklmnopqrstuvwxyz');

    let sessionIdentifier = `${randomString(5, '0123456789abcdefghijklmnopqrstuvwxyz')}-${randomString(13, '0123456789')}`

    let date = randomDate(new Date(2014, 0, 1), new Date());

    let outstandingBalance = balance = total = subtotal = price = (Math.floor(Math.random() * 200) + 50).toFixed(1).toString();

    return {
        id: orderId,
        type: 'orders',
        attributes: {
            // 'record_id': Math.floor(Math.random() * 899999) + 100000,
            'record_id': id,
            'coupon_amount': null,
            'created_at': date,
            'description': faker.commerce.productName(),
            'gift_card_amount': null,
            'outstanding_balance': outstandingBalance,
            'price': price,
            'quantity': 1,
            'status': 'booked',
            'subtotal': subtotal,
            'tax': '0.0',
            'tax_percentage': '0.0',
            'total': total,
            'updated_at': date,
            'verification_code': verificationCode,
            'balance': balance,
            'customer_email': customer.attributes.email,
            'customer_name': `${customer.attributes.first_name} ${customer.attributes.last_name}`,
            'customer_first_name': customer.attributes.first_name,
            'customer_last_name': customer.attributes.last_name,
            'customer_zip': customer.attributes.zip,
            'payment_status': 'completed',
            'session_identifier': sessionIdentifier
        },
        relationships: {
            'coupon': {
                'links': {
                    'self': `https://www.occsn.com/api/v1/orders/${orderId}/relationships/coupon`,
                    'related': `https://www.occsn.com/api/v1/orders/${orderId}/coupon`
                }
            },
            'customer': {
                'links': {
                    'self': `https://www.occsn.com/api/v1/orders/${orderId}/relationships/customer`,
                    'related': `https://www.occsn.com/api/v1/orders/${orderId}/customer`
                }
            }
        },
        links: {
            'self': `https://www.occsn.com/api/v1/orders/${orderId}`
        }
    }
}

function randomString(length, chars) {
    var result = '';

    for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];

    return result;
}

function randomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime())).toISOString();
}

module.exports = () => {
    let customers = [];
    let attributes = [];
    let occurrences = [];

    const data = {
        orders: [],
        ordersWithIncludes: []
    };

    let answers = generateAnswers();

    let questions = generateQuestions();

    let totalPossibleQuestionsAndAnswers = answers.length * questions.length;

    for (let i = 0; i < totalPossibleQuestionsAndAnswers; i++) {
        let question = questions[Math.floor(Math.random() * questions.length)];

        let answer = answers[Math.floor(Math.random() * answers.length)];

        attributes.push(generateAttributeValue(question, answer));
    }

    for (let i = 1; i <= NUM_CUSTOMERS; i++) {
        customers.push(generateCustomer(i));
    }

    for (let i = 1; i <= NUM_OCCURRENCES; i++) {
        occurrences.push(generateOccurence());
    }

    for (let i = 1; i <= NUM_ORDERS; i++) {
        let customer = customers[Math.floor(Math.random() * NUM_CUSTOMERS)];

        let order = generateOrder(customer, i);

        let numAttributeVals = Math.floor(Math.random() * 5) + 1;

        data.orders.push(order);

        let orderWithIncludes = {
            data: [],
            included: [],
            links: {}
        };

        orderWithIncludes.data.push(order);
        orderWithIncludes.included.push(customer);

        for (let j = 0; j < numAttributeVals; j++) {
            let attribute = attributes[Math.floor(Math.random() * totalPossibleQuestionsAndAnswers)];

            orderWithIncludes.included.push(attribute);
        }

        orderWithIncludes.included.push(occurrences[Math.floor(Math.random() * NUM_OCCURRENCES)]);

        data.ordersWithIncludes.push(orderWithIncludes);
    }

    return data
};
