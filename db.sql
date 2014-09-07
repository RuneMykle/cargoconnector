DROP TABLE IF EXISTS messages;

CREATE TABLE messages (
    message_id serial primary key,
    order_id varchar(20) NOT NULL,
    message text NOT NULL,
    processed boolean NOT NULL,
    date_added timestamp default NULL
);