require('babel-polyfill');

import server from 'express';
import asyncHandler from 'express-async-handler';
import BookGenerator from 'booktoread';

import RedisClient from './redis.js';
import enableCaching from './cache.js';

const app = server();
const redis = new RedisClient('redis');
const getBook = enableCaching(() => 'book', getRandomBook, redis);

app.get('/books', asyncHandler(async (req, res, next) => {
    let book = await getBook();
    res.send({ book: book});
}));

function getRandomBook() {
    return BookGenerator.random();
}

app.listen(3000);