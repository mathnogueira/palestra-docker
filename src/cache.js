export default function enableCaching(keyFn, actionFn, redis) {
    return async function() {
        const key = keyFn();
        let cachedValue = await redis.get(key);
        let item;
        if (cachedValue === null) {
            item = actionFn();
            redis.set(key, JSON.stringify(item));
        } else {
            item = JSON.parse(cachedValue);
        }

        return item;
    }
}