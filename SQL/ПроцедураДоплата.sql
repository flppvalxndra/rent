-- �������

CREATE PROC �������������������
@num int,
@date1 datetime, -- ����� ������ �������
@date2 datetime  -- ����� ��������
AS
BEGIN
INSERT INTO �������(�����_��������,�����,�����_������_�������)
VALUES (@date2,@num,@date1)
UPDATE ������������
SET ������ = 0
FROM ������������
WHERE �����������_����� = ANY(SELECT �����������_����� FROM ������_���� WHERE ����� = @num and ���� = @date1);
	
IF (SELECT DATEADD(mi,10,DATEADD(hh,����_������,����)) FROM ��� WHERE ����� = @num and ���� = @date1) <= @date2
    begin
	DECLARE @pay float = CAST(ROUND(
	                   (DATEDIFF(mi,@date1,@date2) -- � �������
	                   - (SELECT ����_������*60 FROM ��� WHERE ����� = @num and ���� = @date1))
					   -- ���� �� ��� � ���� �� ������
					   * (SELECT (���������_��_�������/����_������)/60 FROM ��� WHERE ����� = @num and ���� = @date1)
					   ,2) as decimal(18,2))
	INSERT INTO �������(�����,�����_������_�������,�����)
    VALUES (@num,@date1,@pay)

	SELECT ����� as [����� �������]
	FROM �������
	WHERE ����� = @num and �����_������_������� = @date1
	end;
ELSE 
	SELECT '������������ ���������� �������' as [����� �������]

END;



