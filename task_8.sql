
-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

WITH friend AS (
	SELECT to_user_id AS friend_id FROM messages WHERE from_user_id = 1
	union ALL
	SELECT from_user_id  FROM messages WHERE to_user_id = 2
)
SELECT u.first_name, u.last_name, count(*) as rate FROM friend
	INNER JOIN users U 
		ON u.id = friend.friend_id
GROUP BY friend_id
ORDER BY rate DESC;


-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.  Смог посчитать только молодых пользователей. С таблицей с лайками беда...

SELECT id, first_name FROM users U
	  INNER JOIN profiles P 
	  	ON P.user_id = U.id
	ORDER BY P.birthday
	LIMIT 10;


-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

WITH T AS (
	SELECT from_user_id as user_id, COUNT(*) as rnk  FROM messages 
	GROUP BY from_user_id
	UNION ALL
	SELECT user_id, COUNT(*)  FROM friendships
	GROUP BY user_id
	UNION ALL
	SELECT friend_id, COUNT(*)  FROM friendships 
	GROUP BY friend_id
	UNION ALL
	SELECT user_id, COUNT(*)  FROM communities_users
	GROUP BY user_id
)
SELECT first_name, SUM(T.rnk) AS rnk
FROM T
	INNER JOIN users U on U.id = T.user_id
GROUP BY first_name
ORDER BY rnk
LIMIT 5;



