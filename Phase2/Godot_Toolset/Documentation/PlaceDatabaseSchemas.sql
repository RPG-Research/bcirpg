CREATE TABLE Place (
    PlaceID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Type VARCHAR(255) NOT NULL,
    ParentPlaceID INT,
    FOREIGN KEY (ParentPlaceID) REFERENCES Place(PlaceID)
);

CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    PlaceID INT,
    FOREIGN KEY (PlaceID) REFERENCES Place(PlaceID)
);

CREATE TABLE Location (
    LocationID INT PRIMARY KEY,
    PlaceID INT,
    FOREIGN KEY (PlaceID) REFERENCES Place(PlaceID)
);

CREATE TABLE Scene (
    SceneID INT PRIMARY KEY,
    PlaceID INT,
    FOREIGN KEY (PlaceID) REFERENCES Place(PlaceID)
);

CREATE TABLE ContentCapsule (
    ContentCapsuleID INT PRIMARY KEY,
    SceneID INT,
    Description TEXT,
    Visuals TEXT,
    FOREIGN KEY (SceneID) REFERENCES Scene(SceneID)
);

CREATE TABLE Space (
    SpaceID INT PRIMARY KEY,
    PlaceID INT,
    Height INT,
    Width INT,
    Depth INT,
    unitOfMeasure INT
    FOREIGN KEY (PlaceID) REFERENCES Place(PlaceID)
);



-- 
-- The `ParentPlaceID` attribute in the `Place` table is used to establish a hierarchical relationship among the different types of places, such as regions, locations, scenes, and spaces. This attribute is essentially a foreign key that references the `PlaceID` within the same table. It allows you to define a parent-child relationship between places, which can be crucial for organizing and structuring the different elements of your game.
-- 
-- By using this attribute, you can create a hierarchical structure, where a location may be part of a specific region, a scene may be part of a particular location, and a space may be associated with a specific scene or location. This kind of hierarchical organization helps to maintain the relationships between different places within the game environment.
-- 
-- For example, consider a scenario where you have multiple locations within a region, and each location contains various scenes and spaces. By utilizing the `ParentPlaceID`, you can easily track which location belongs to which region and which scene or space is associated with a particular location. This hierarchy can be instrumental in querying and organizing your game data, enabling you to retrieve specific information related to the relationships between different places.