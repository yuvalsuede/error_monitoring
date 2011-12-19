/* Table for JavaScript errors */
CREATE TABLE IF NOT EXISTS js_errors (
    `time` datetime NOT NULL,
    count int(11) default NULL,  
    context varchar(100) default NULL,
    `browser` varchar(50) default NULL,  
    `device` varchar(100) default NULL,  
    PRIMARY KEY  (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
