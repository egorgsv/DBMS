SELECT ENAME, JOB FROM EMP
/
SELECT DEPT.DNAME, COUNT(EMP.EMPNO) AS COUNT
FROM DEPT
LEFT OUTER JOIN EMP ON EMP.DEPTNO = DEPT.DEPTNO
GROUP BY DEPT.DNAME
/
SELECT JOB, AVG(SAL) FROM EMP
GROUP BY JOB
ORDER BY AVG(SAL) DESC
/
SELECT JOB, MIN(SAL), MAX(SAL) FROM EMP
GROUP BY JOB
ORDER BY MIN(SAL) ASC
/
SELECT DEPT.DNAME, SUM(SAL) FROM DEPT
LEFT OUTER JOIN EMP ON EMP.DEPTNO = DEPT.DEPTNO
GROUP BY DEPT.DNAME
/
SELECT EMP1.ENAME, EMP1.JOB, EMP2.ENAME, EMP2.JOB FROM EMP EMP1 CROSS JOIN EMP EMP2
WHERE EMP1.JOB = 'MANAGER' AND EMP2.JOB = 'MANAGER'
AND EMP1.EMPNO < EMP2.EMPNO
/