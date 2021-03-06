USE [AlphaOneDB]
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddMapping]    Script Date: 12/17/2020 9:45:19 AM ******/
DROP PROCEDURE [dbo].[Sp_AddMapping]
GO
/****** Object:  StoredProcedure [dbo].[Sp_AddMapping]    Script Date: 12/17/2020 9:45:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- =============================================
CREATE PROCEDURE [dbo].[Sp_AddMapping]
	-- Add the parameters for the stored procedure here
@fromName nvarchar(max),
@toName nvarchar(max)


AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @FN nvarchar(max)
	DECLARE @TN nvarchar(max)
	DECLARE @FL int
	DECLARE @TL int
	DECLARE @FID int
	DECLARE @TID int

	BEGIN

	SET @FN = @fromName
	SET @TN = @toName

	SET @FL = (select LEN(@FN));
	SET @TL = (select LEN(@TN));

	IF((select 1 from EnglishViews where replacedcol = @fromName) =1 )
	BEGIN 
		SET @FID =( select Id from EnglishViews where replacedcol = @fromName)
	END
	ELSE
	BEGIN
	--update
		insert into EnglishCharacters (Character,SubCharacterCount) values (@fromName,@FL)
		SET @FID =( select Id from EnglishViews  where replacedcol = @fromName)
	END

	
	IF((select 1 from SinhalaViews where replacedcol = @toName) =1 )
	BEGIN 
		SET @TID =( select Id from SinhalaViews where replacedcol = @toName)
	END
	ELSE
	BEGIN
	--update
		insert into SinhalaCharacters (Character,SubCharacterCount) values (@toName,@TL)
		SET @TID =( select Id from SinhalaViews  where replacedcol = @toName)
	END
	
	IF((select 1 from StringConvertorEnglishToSinhala where FromLanguageCharacterId = @FID AND ToLanguageCharacterId = @TID)=1)
	BEGIN
		select 1 from StringConvertorEnglishToSinhala where FromLanguageCharacterId = @FID AND ToLanguageCharacterId = @TID
	END
	ELSE
	BEGIN
		insert into StringConvertorEnglishToSinhala (PriorityValueFromLanguage,PriorityValueToLanguage,FromLanguageCharacterId,ToLanguageCharacterId)
		values (20,20,@FID,@TID)

		select * from StringConvertorEnglishToSinhala where FromLanguageCharacterId = @FID AND ToLanguageCharacterId = @TID
	END
	
	IF((select 1 from StringConvertorSinhalaToEnglish where FromLanguageCharacterId = @TID AND ToLanguageCharacterId = @FID)=1)
	BEGIN
		select 1 from StringConvertorSinhalaToEnglish where FromLanguageCharacterId = @TID AND ToLanguageCharacterId = @FID
	END
	ELSE
	BEGIN
		insert into StringConvertorSinhalaToEnglish (PriorityValueFromLanguage,PriorityValueToLanguage,FromLanguageCharacterId,ToLanguageCharacterId)
		values (20,20,@TID,@FID)

		select * from StringConvertorSinhalaToEnglish where FromLanguageCharacterId = @TID AND ToLanguageCharacterId = @FID
	END
	END


END
GO
