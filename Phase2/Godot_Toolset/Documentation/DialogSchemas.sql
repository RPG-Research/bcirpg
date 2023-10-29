CREATE TABLE Tags (
    TagID SERIAL PRIMARY KEY,
    TagName VARCHAR(255) NOT NULL
);

CREATE TABLE DialogOptions (
    OptionID SERIAL PRIMARY KEY,
    DialogContent TEXT NOT NULL
);

CREATE TABLE DialogOptions_Tags (
    OptionID INT,
    TagID INT,
    PRIMARY KEY (OptionID, TagID),
    FOREIGN KEY (OptionID) REFERENCES DialogOptions(OptionID),
    FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);
