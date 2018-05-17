const redis = require('redis');
const {promisify} = require('util');

export default class RedisClient {
    constructor(host) {
        this._client = redis.createClient({host: host});
        this.getAsync = promisify(this._client.get).bind(this._client);
    }

    set(key, value) {
        this._client.set(key, value, 'EX', 7);
    }

    get(key) {
        return this.getAsync(key);
    }
}