USE [master]
GO
/****** Object:  Database [ITI]    Script Date: 12/22/2024 3:46:43 PM ******/
CREATE DATABASE [ITI]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ITI', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ITI.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ITI_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ITI_log.ldf' , SIZE = 9216KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ITI] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ITI].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ITI] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ITI] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ITI] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ITI] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ITI] SET ARITHABORT OFF 
GO
ALTER DATABASE [ITI] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ITI] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ITI] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ITI] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ITI] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ITI] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ITI] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ITI] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ITI] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ITI] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ITI] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ITI] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ITI] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ITI] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ITI] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ITI] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ITI] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ITI] SET RECOVERY FULL 
GO
ALTER DATABASE [ITI] SET  MULTI_USER 
GO
ALTER DATABASE [ITI] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [ITI] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ITI] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ITI] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [ITI] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ITI] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ITI] SET QUERY_STORE = OFF
GO
USE [ITI]
GO
/****** Object:  User [koko]    Script Date: 12/22/2024 3:46:44 PM ******/
CREATE USER [koko] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ITIStud]    Script Date: 12/22/2024 3:46:44 PM ******/
CREATE USER [ITIStud] FOR LOGIN [ITIStud] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [iti]    Script Date: 12/22/2024 3:46:44 PM ******/
CREATE USER [iti] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [iti]    Script Date: 12/22/2024 3:46:44 PM ******/
CREATE SCHEMA [iti]
GO
/****** Object:  Schema [ST]    Script Date: 12/22/2024 3:46:44 PM ******/
CREATE SCHEMA [ST]
GO
/****** Object:  UserDefinedFunction [dbo].[getname]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getname](@format varchar(20))RETURNS @t TABLE (Student_name Varchar(50))AS	BEGIN		IF @format = 'first name'		INSERT INTO @t		SELECT St_Fname FROM Student		ELSE IF @format = 'last name'		INSERT INTO @t		SELECT St_Lname FROM Student		ELSE IF @format = 'Full name'		INSERT INTO @t		SELECT CONCAT_WS(' ',St_Fname,St_Lname) FROM Student		RETURN	END
GO
/****** Object:  UserDefinedFunction [dbo].[getstudentname]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getstudentname](@id int)
RETURNS varchar(50)
	BEGIN
		DECLARE @msg varchar(50), @fname varchar(20), @lname varchar(20)

		SELECT @fname = ST_Fname, @lname = ST_Lname FROM Student WHERE St_Id = @id
		IF @fname IS NULL AND @lname IS NULL
			SELECT @msg = 'First name & last name are null'
		ELSE IF @fname IS NULL 
			SELECT @msg = 'First name is null'
		ELSE IF @lname IS NULL
			SELECT @msg = 'Last name is null'
		ELSE
			SELECT @msg = 'First name and Last name are not null'
		RETURN @msg
	END
GO
/****** Object:  UserDefinedFunction [dbo].[MidValues]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MidValues](@start int, @end int)
RETURNS @midValues TABLE
(
	mid INT
)
AS
BEGIN
	IF @start < @end
	BEGIN
		
		DECLARE @counter INT = @start +1
		WHILE @counter < @end

		BEGIN
			INSERT INTO @midValues (mid)
			VALUES (@counter)
			SET @counter = @counter + 1
		END
	END
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[monthname]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[monthname](@date date)
RETURNS NVARCHAR(20)
	BEGIN 
		declare @month VARCHAR(20)
			SELECT @month = format(@date,'MMMM')
		RETURN @month
	END
GO
/****** Object:  Table [dbo].[Course]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[Crs_Id] [int] NOT NULL,
	[Crs_Name] [nvarchar](50) NULL,
	[Crs_Duration] [int] NULL,
	[Top_Id] [int] NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[Crs_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stud_Course]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stud_Course](
	[Crs_Id] [int] NOT NULL,
	[St_Id] [int] NOT NULL,
	[Grade] [int] NULL,
 CONSTRAINT [PK_Stud_Course] PRIMARY KEY CLUSTERED 
(
	[Crs_Id] ASC,
	[St_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[St_Id] [int] NOT NULL,
	[St_Fname] [nvarchar](50) NULL,
	[St_Lname] [nchar](10) NULL,
	[St_Address] [nvarchar](100) NULL,
	[St_Age] [int] NULL,
	[Dept_Id] [int] NULL,
	[St_super] [int] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[St_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StName]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[StName]
AS
	SELECT CONCAT_WS(' ',St_Fname,St_Lname) AS [Full Name], Crs_Name
	FROM Student S INNER JOIN Stud_Course SC
	ON S.St_Id = SC.St_Id
	INNER JOIN Course C
	ON C.Crs_Id = SC.Crs_Id
	WHERE SC.Grade > 50
GO
/****** Object:  Table [dbo].[Topic]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topic](
	[Top_Id] [int] NOT NULL,
	[Top_Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_Topic] PRIMARY KEY CLUSTERED 
(
	[Top_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_Course]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_Course](
	[Ins_Id] [int] NOT NULL,
	[Crs_Id] [int] NOT NULL,
	[Evaluation] [nvarchar](50) NULL,
 CONSTRAINT [PK_Ins_Course] PRIMARY KEY CLUSTERED 
(
	[Ins_Id] ASC,
	[Crs_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Instructor]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructor](
	[Ins_Id] [int] NOT NULL,
	[Ins_Name] [nvarchar](50) NULL,
	[Ins_Degree] [nvarchar](50) NULL,
	[Salary] [money] NULL,
	[Dept_Id] [int] NULL,
 CONSTRAINT [PK_Instructor] PRIMARY KEY CLUSTERED 
(
	[Ins_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 12/22/2024 3:46:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Dept_Id] [int] NOT NULL,
	[Dept_Name] [nvarchar](50) NULL,
	[Dept_Desc] [nvarchar](100) NULL,
	[Dept_Location] [nvarchar](50) NULL,
	[Dept_Manager] [int] NULL,
	[Manager_hiredate] [date] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Dept_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
