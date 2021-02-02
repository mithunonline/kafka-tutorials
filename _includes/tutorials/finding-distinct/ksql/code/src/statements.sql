CREATE STREAM CLICKS (IP_ADDRESS STRING, URL STRING, TIMESTAMP STRING)
    WITH (KAFKA_TOPIC = 'CLICKS',
          KEY_FORMAT='JSON',
          VALUE_FORMAT = 'JSON',
          TIMESTAMP = 'TIMESTAMP',
          TIMESTAMP_FORMAT = 'yyyy-MM-dd''T''HH:mm:ssXXX',
          PARTITIONS = 1);

CREATE TABLE DETECTED_CLICKS AS
    SELECT
        IP_ADDRESS AS KEY1,
        URL AS KEY2,
        TIMESTAMP AS KEY3,
        AS_VALUE(IP_ADDRESS) AS IP_ADDRESS,
        AS_VALUE(URL) AS URL,
        AS_VALUE(TIMESTAMP) AS TIMESTAMP
    FROM CLICKS WINDOW TUMBLING (SIZE 2 MINUTES, RETENTION 3650 DAYS)
    GROUP BY IP_ADDRESS, URL, TIMESTAMP
    HAVING COUNT(IP_ADDRESS) = 1;


CREATE STREAM DISTINCT_CLICKS (IP_ADDRESS STRING, URL STRING, TIMESTAMP STRING)
    WITH (KAFKA_TOPIC = 'DETECTED_CLICKS',
    VALUE_FORMAT = 'JSON');
