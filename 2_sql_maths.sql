USE Chinook;


-- 1. What's the difference between the largest and the smallest invoice price?
SELECT 
    MAX(Total) - MIN(total)
FROM
    Invoice;

-- 2. What is the difference in length between the longest and shortest track in minutes?
SELECT 
    (MAX(Milliseconds) - MIN(Milliseconds)) / 60000 AS DifferenceDuration
FROM
    track;

-- 3. What is the average length of a track in the 'Rock' genre in minutes?
SELECT 
	AVG(Milliseconds) / (1000 * 60) AS AVG_track_length_in_Mins 
FROM
    Track t
        JOIN
    Genre g ON t.GenreId = g.GenreId
WHERE
    g.Name = 'Rock';
    
SELECT 
    AVG(t.milliseconds) / 60000 AS AverageLengthMinutes
FROM
    track t
        JOIN
    genre g USING (genreid)
WHERE
    g.name = 'Rock';

-- 4. What is the average length of a 'Rock' track in minutes, rounded to 2 decimal places?
SELECT 
    ROUND(AVG(Milliseconds) / 60000, 2) AS AverageLengthMinutes
FROM
    Genre g
        JOIN
    Track t USING (GenreId)
WHERE
    g.Name = 'Rock';

-- 5. What is the average length of a 'Rock' track in minutes, rounded down to the nearest integer?
SELECT 
    FLOOR(AVG(Milliseconds) / 60000) AS AverageLengthMinutes
FROM
    Genre g
        JOIN
    Track t USING (GenreId)
WHERE
    g.Name = 'Rock';

-- 6. What is the average length of a 'Rock' track in minutes, rounded up to the nearest integer?

SELECT 
    CEIL(AVG(Milliseconds) / 60000) AS AverageLengthMinutes
FROM
    Genre g
        JOIN
    Track t USING (GenreId)
WHERE
    g.Name = 'Rock';
    
-- 7. What is the total length of all tracks for each genre in minutes.
-- Order them from largest to smallest length of time.
SELECT 
	g.name, SUM(Milliseconds / (1000 * 60)) AS Total_length_in_Mins 
FROM
    Track t
        JOIN
    Genre g ON t.GenreId = g.GenreId
GROUP BY
    g.Name
ORDER BY Total_length_in_Mins DESC;

-- 8. How many tracks have a length between 3 and 5 minutes?
SELECT 
    COUNT(trackid) 
FROM
    track
WHERE Milliseconds/60000 BETWEEN 3 AND 5;

-- 9. If each song costs $1.27, how much would it cost to buy all the songs in the 'Classical' genre?
SELECT 
    COUNT(TrackId) * 1.27
FROM
    Genre g
        JOIN
    Track t USING (GenreId)
WHERE
    g.Name = 'Classical';

-- 10. How many more composers are there than artists?
SELECT 
    COUNT(DISTINCT (a.ArtistId)) AS artist,
    COUNT(DISTINCT (t.Composer)) AS composer,
    COUNT(DISTINCT (t.Composer)) - COUNT(DISTINCT (a.ArtistId)) AS composers_more
FROM
    Track t
        JOIN
    Album a USING (AlbumId);
    
SELECT * FROM Artist;
SELECT COUNT(DISTINCT Composer) FROM Track;
SELECT COUNT(DISTINCT Name) FROM Artist;
SELECT 852-275;

SELECT 
    COUNT(DISTINCT (t.composer)) - COUNT(DISTINCT (a.artistid)) AS Difference
FROM
    track t
        LEFT JOIN
    album al USING (albumid)
        LEFT JOIN
    artist a USING (artistid);
    
SELECT 
    COUNT(DISTINCT (t.composer)) - COUNT(DISTINCT (a.artistid)) AS Difference
FROM
    track t
        RIGHT JOIN
    album al USING (albumid)
        RIGHT JOIN
    artist a USING (artistid);

-- 11. Which 'Metal' genre albums have an odd number of tracks?

SELECT 
    al.albumid AS AlbumId,
    al.title AS AlbumTitle,
    COUNT(t.trackid) AS NumberOfTracks
FROM
    Album al
        JOIN
    Track t USING (AlbumId)
        JOIN
    Genre g USING (GenreId)
WHERE
    g.name = 'Metal'
GROUP BY al.title, al.albumid, al.title 
HAVING COUNT(t.TrackId) % 2 = 1;

-- 12. What is the average invoice total rounded to the nearest whole number?
SELECT 
    ROUND(AVG(Total)) AS AverageInvoiceTotal
FROM
    invoice;

-- 13. Classify tracks as 'Short', 'Medium', or 'Long' based on their length.
-- Long is 5 minutes or longer. Short is less than 3 minutes.

SELECT 
    trackid,
    Name,
    CASE
        WHEN Milliseconds >= 300000 THEN 'Long'
        WHEN MIlliseconds < 180000 THEN 'Short'
        WHEN Milliseconds BETWEEN 180000 AND 300000 THEN 'Medium'
    END AS Length
FROM
    Track;
    
SELECT 
	trackid,
    Name,
    CASE
        WHEN Milliseconds / 60000 < 3 THEN 'Short'
        WHEN Milliseconds / 60000 < 5 THEN 'Medium'
        ELSE 'Long'
    END AS LengthCategory
FROM
    track;


-- 14. Taking into consideration the unitprice and the quantity sold,
-- rank the songs from highest grossing to lowest.
-- Include the track name and the artist.

SELECT 
    a.name AS Artist,
    t.name AS Track,
    SUM(il.unitprice * il.quantity) AS Gross
FROM
    invoiceline il
        LEFT JOIN
    track t USING (trackid)
        LEFT JOIN
    album al USING (albumid)
        LEFT JOIN
    artist a USING (artistid)
		LEFT JOIN
	mediatype m USING (mediatypeid)
WHERE m.name LIKE '%audio%'
GROUP BY il.trackid
ORDER BY Gross DESC;

SELECT * FROM mediatype;