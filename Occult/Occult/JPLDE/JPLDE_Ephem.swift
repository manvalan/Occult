//
//  MOJPLEphem.swift
//  MacOccult
//
//  Created by Michele Bigi on 30/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class JPLDE_Ephem : AstroBase {
    
    var StartPointer  : [ Int ] = [ 3, 171, 231, 309, 342, 366, 387, 405, 423, 441, 753, 819,  899 ]
    var NumOfCoeff    : [ Int ] = [ 14, 10, 13, 11, 8, 7, 6, 6, 6, 13, 11, 10, 10 ]
    var NumOfIntervals: [ Int ] = [ 4, 2, 2, 1, 1, 1, 1, 1, 1, 8, 2, 4, 4]
    var Intervals     : [ Int ] = [  8, 16, 16, 32, 32, 32, 32, 32, 32, 4, 16, 8, 8 ]
    let DE_Ephemeris_Version : String = { "DE_Ephemeris.bin" }()
    var EphemerisVersion : Int = 0
    var LongEphemerisVersion : Int = 0
    let DE_LongEphemeris_Version : String = { "DE_LongEphemeris.bin" }()
    var DE_EphemerisAvailable : Bool = false
    var DE_LongEphemerisAvailable : Bool = false
    var JDStart : Double = 2305424.5
    var JDEnd   : Double = 2525008.5
    var JDStartLong : Double = 2305424.5
    var JDEndLong   : Double = 2525008.5
    var Initialised : Bool = false
    let AUkm : Double = 149597870.7
    let EarthMoonRatio : Double = 81.3005690741906
    let EarthFromBarycentre : Double = 0.0121505842699404
    let UnitLightTime : Double = 0.0057756
    var AppPath : String = ""
    
    
}

/****

 public static string DE_Ephemeris_Version = "DE_Ephemeris.bin";
 internal static int EphemerisVersion = 0;
 internal static int LongEphemerisVersion = 0;
 public static string DE_LongEphemeris_Version = "DE_LongEphemeris.bin";
 internal static bool DE_EphemerisAvailable = false;
 internal static bool DE_LongEphemerisAvailable = false;
 
 public static double JDStart = 2305424.5;
 public static double JDEnd = 2525008.5;
 public static double JDStartLong = 2305424.5;
 public static double JDEndLong = 2525008.5;
 internal static bool Initialised = false;
 
 
 public static string AppPath;
 private const double AUkm = 149597870.7;
 private const double EarthMoonRatio = 81.3005690741906;
 private const double EarthFromBarycentre = 0.0121505842699404;
 private const double UnitLightTime = 0.0057756;
 
 public static Create_JPL_DE_EphemerisFile CreateDEfile;
 
 internal static void InitialiseDE_Ephemeris()
 {
 char[] buffer = new char[200];
 if (File.Exists(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_Ephemeris_Version))
 {
 using (StreamReader streamReader = new StreamReader(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_Ephemeris_Version))
 {
 streamReader.ReadBlock(buffer, 0, 200);
 string upper = new string(buffer, 0, 200).ToUpper();
 if (!int.TryParse(upper.Substring(upper.IndexOf("DE") + 2, 3), out JPL_DE.EphemerisVersion))
 JPL_DE.EphemerisVersion = 0;
 int num = upper.IndexOf("=");
 JPL_DE.JDStart = double.Parse(upper.Substring(num + 1, 11));
 JPL_DE.JDEnd = double.Parse(upper.Substring(upper.IndexOf("=", num + 1) + 1, 11));
 JPL_DE.DE_EphemerisAvailable = true;
 }
 }
 else
 {
 JPL_DE.JDStart = 0.0;
 JPL_DE.JDEnd = -1.0;
 JPL_DE.DE_EphemerisAvailable = false;
 }
 if (File.Exists(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_LongEphemeris_Version))
 {
 using (StreamReader streamReader = new StreamReader(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_LongEphemeris_Version))
 {
 streamReader.ReadBlock(buffer, 0, 200);
 string upper = new string(buffer, 0, 200).ToUpper();
 if (!int.TryParse(upper.Substring(upper.IndexOf("DE") + 2, 3), out JPL_DE.LongEphemerisVersion))
 JPL_DE.LongEphemerisVersion = 0;
 int num = upper.IndexOf("=");
 JPL_DE.JDStartLong = double.Parse(upper.Substring(num + 1, 11));
 JPL_DE.JDEndLong = double.Parse(upper.Substring(upper.IndexOf("=", num + 1) + 1, 11));
 JPL_DE.DE_LongEphemerisAvailable = true;
 }
 }
 else
 {
 JPL_DE.DE_LongEphemerisAvailable = false;
 JPL_DE.JDStartLong = 0.0;
 JPL_DE.JDEndLong = -1.0;
 }
 JPL_DE.Initialised = true;
 }
 
 public static void Show_CreateJPL_DE(int Tab)
 {
 Create_JPL_DE_EphemerisFile.OpeningTab = Tab;
 try
 {
 JPL_DE.CreateDEfile.Show();
 }
 catch
 {
 JPL_DE.CreateDEfile = new Create_JPL_DE_EphemerisFile();
 JPL_DE.CreateDEfile.Show();
 }
 }
 
 public static bool DE_Ephemeris(double JD, int Planet, out double x2000, out double y2000, out double z2000, out int Version)
 {
 if (!JPL_DE.Initialised)
 JPL_DE.InitialiseDE_Ephemeris();
 double[] numArray1 = new double[14];
 double[] numArray2 = new double[14];
 double[] numArray3 = new double[14];
 double[] numArray4 = new double[14];
 x2000 = y2000 = z2000 = (double) (Version = 0);
 if (Planet > 11 | Planet < 1)
 return false;
 string ephemerisVersion;
 long num1;
 double num2;
 if (JD >= JPL_DE.JDStart & JD < JPL_DE.JDEnd)
 {
 ephemerisVersion = JPL_DE.DE_Ephemeris_Version;
 Version = JPL_DE.EphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStart) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStart) % 32.0;
 }
 else
 {
 if (!(JD >= JPL_DE.JDStartLong & JD < JPL_DE.JDEndLong))
 return false;
 ephemerisVersion = JPL_DE.DE_LongEphemeris_Version;
 Version = JPL_DE.LongEphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStartLong) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStartLong) % 32.0;
 }
 FileStream fileStream = new FileStream(JPL_DE.AppPath + "\\Resource Files\\" + ephemerisVersion, FileMode.Open, FileAccess.Read);
 BinaryReader binaryReader = new BinaryReader((Stream) fileStream);
 int num3 = (int) num2 / JPL_DE.Interval[Planet - 1];
 int num4 = JPL_DE.NumOfCoeff[Planet - 1];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[Planet - 1] - 1)) + (long) (24 * JPL_DE.NumOfCoeff[Planet - 1] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray3[index] = binaryReader.ReadDouble();
 double num5 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[Planet - 1])) / (double) JPL_DE.Interval[Planet - 1]) - 1.0;
 double num6 = 2.0 * num5;
 numArray4[0] = 1.0;
 numArray4[1] = num5;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num6 * numArray4[index - 1] - numArray4[index - 2];
 double num7 = 0.0;
 double num8 = 0.0;
 double num9 = 0.0;
 for (int index = 0; index < num4; ++index)
 num7 += numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num8 += numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num9 += numArray3[index] * numArray4[index];
 if (Planet < 10)
 {
 num3 = (int) num2 / JPL_DE.Interval[10];
 num4 = JPL_DE.NumOfCoeff[10];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[10] - 1)) + (long) (24 * JPL_DE.NumOfCoeff[10] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray3[index] = binaryReader.ReadDouble();
 double num10 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[10])) / (double) JPL_DE.Interval[10]) - 1.0;
 double num11 = 2.0 * num10;
 numArray4[0] = 1.0;
 numArray4[1] = num10;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num11 * numArray4[index - 1] - numArray4[index - 2];
 for (int index = 0; index < num4; ++index)
 num7 -= numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num8 -= numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num9 -= numArray3[index] * numArray4[index];
 }
 if (Planet == 3)
 {
 num3 = (int) num2 / JPL_DE.Interval[9];
 num4 = JPL_DE.NumOfCoeff[9];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[9] - 1)) + (long) (24 * JPL_DE.NumOfCoeff[9] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray3[index] = binaryReader.ReadDouble();
 if (JPL_DE.Interval[9] != JPL_DE.Interval[Planet - 1])
 {
 double num10 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[9])) / (double) JPL_DE.Interval[9]) - 1.0;
 double num11 = 2.0 * num10;
 numArray4[0] = 1.0;
 numArray4[1] = num10;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num11 * numArray4[index - 1] - numArray4[index - 2];
 }
 for (int index = 0; index < num4; ++index)
 num7 -= 0.0121505842699404 * numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num8 -= 0.0121505842699404 * numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num9 -= 0.0121505842699404 * numArray3[index] * numArray4[index];
 }
 if (Planet == 10)
 {
 double num10 = Math.Sqrt(num7 * num7 + num8 * num8 + num9 * num9) / 149597870.7 * 0.0057756;
 double num11 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[Planet - 1]) - num10) / (double) JPL_DE.Interval[Planet - 1]) - 1.0;
 double num12 = 2.0 * num11;
 numArray4[0] = 1.0;
 numArray4[1] = num11;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num12 * numArray4[index - 1] - numArray4[index - 2];
 double num13;
 double num14 = num13 = 0.0;
 double num15 = num13;
 double num16 = num13;
 for (int index = 0; index < num4; ++index)
 num16 += numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num15 += numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num14 += numArray3[index] * numArray4[index];
 x2000 = num16;
 y2000 = num15;
 z2000 = num14;
 }
 else
 {
 x2000 = num7 / 149597870.7;
 y2000 = num8 / 149597870.7;
 z2000 = num9 / 149597870.7;
 }
 fileStream.Close();
 return true;
 }
 
 public static bool DE_Nutation(double JD, out double NutL, out double NutE, out int Version)
 {
 if (!JPL_DE.Initialised)
 JPL_DE.InitialiseDE_Ephemeris();
 double[] numArray1 = new double[14];
 double[] numArray2 = new double[14];
 double[] numArray3 = new double[14];
 NutL = NutE = (double) (Version = 0);
 string ephemerisVersion;
 long num1;
 double num2;
 if (JD >= JPL_DE.JDStart & JD < JPL_DE.JDEnd)
 {
 ephemerisVersion = JPL_DE.DE_Ephemeris_Version;
 Version = JPL_DE.EphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStart) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStart) % 32.0;
 }
 else
 {
 if (!(JD >= JPL_DE.JDStartLong & JD < JPL_DE.JDEndLong))
 return false;
 ephemerisVersion = JPL_DE.DE_LongEphemeris_Version;
 Version = JPL_DE.LongEphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStartLong) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStartLong) % 32.0;
 }
 FileStream fileStream = new FileStream(JPL_DE.AppPath + "\\Resource Files\\" + ephemerisVersion, FileMode.Open, FileAccess.Read);
 BinaryReader binaryReader = new BinaryReader((Stream) fileStream);
 int num3 = (int) num2 / JPL_DE.Interval[11];
 int num4 = JPL_DE.NumOfCoeff[11];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[11] - 1)) + (long) (16 * JPL_DE.NumOfCoeff[11] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 if (numArray1[0] == 0.0 & numArray1[1] == 0.0)
 return false;
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 double num5 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[11])) / (double) JPL_DE.Interval[11]) - 1.0;
 double num6 = 2.0 * num5;
 numArray3[0] = 1.0;
 numArray3[1] = num5;
 for (int index = 2; index < num4; ++index)
 numArray3[index] = num6 * numArray3[index - 1] - numArray3[index - 2];
 for (int index = 0; index < num4; ++index)
 NutL += numArray1[index] * numArray3[index];
 for (int index = 0; index < num4; ++index)
 NutE += numArray2[index] * numArray3[index];
 return true;
 }
 
 internal static string GetDE_VersionDetails(string DE_Version)
 {
 string Version;
 string Years;
 JPL_DE.GetDE_VersionDetails(DE_Version, out Version, out Years);
 return Version + " " + Years;
 }
 
 internal static void GetDE_VersionDetails(string DE_Version, out string Version, out string Years)
 {
 Years = "(?/?)";
 Version = "?";
 if (DE_Version.Length < 1)
 return;
 using (StreamReader streamReader = new StreamReader(JPL_DE.AppPath + "\\Resource Files\\" + DE_Version))
 {
 char[] buffer = new char[256];
 streamReader.Read(buffer, 0, 256);
 string str = new string(buffer);
 int startIndex = str.IndexOf("DE");
 if (startIndex >= 0)
 {
 Version = str.Substring(startIndex, 5);
 int num = str.IndexOf("DE", startIndex + 2);
 if (num >= 0 & num < 80)
 Version = Version + "," + str.Substring(num + 2, 3);
 }
 else
 Version = "???";
 Years = "(" + (JPL_DE.ExtractYear(str.Substring(84, 80)) + 1).ToString() + "/" + JPL_DE.ExtractYear(str.Substring(168, 80)).ToString() + ")";
 }
 }
 
 private static int ExtractYear(string Ln)
 {
 int startIndex = Ln.IndexOf(".") + 2;
 int num = Ln.IndexOf(" ", startIndex + 1);
 if (num - startIndex > 8)
 num = Ln.IndexOf("-", startIndex + 1);
 int result;
 if (!int.TryParse(Ln.Substring(startIndex, num - startIndex), out result))
 result = 0;
 return result;
 }
 
 internal static bool Set_DE_EphemerisFile(string DE_File)
 {
 if (!JPL_DE.ReNameEphemerisToDEVersion(false))
 {
 int num = (int) MessageBox.Show("Can't rename the current DE_Ephemeris file\r\n\r\nTherefore cannot set a new file for the DE_LongEphemeris", "Can't rename", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
 return false;
 }
 File.Move(JPL_DE.AppPath + "\\Resource Files\\" + DE_File, JPL_DE.AppPath + "\\Resource Files\\DE_Ephemeris.bin");
 JPL_DE.InitialiseDE_Ephemeris();
 return true;
 }
 
 internal static bool Set_DE_LongEphemerisFile(string DE_File)
 {
 if (!JPL_DE.ReNameEphemerisToDEVersion(true))
 {
 int num = (int) MessageBox.Show("Can't rename the current DE_LongEphemeris file\r\n\r\nTherefore cannot set a new file for the DE_LongEphemeris", "Can't rename", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
 return false;
 }
 File.Move(JPL_DE.AppPath + "\\Resource Files\\" + DE_File, JPL_DE.AppPath + "\\Resource Files\\DE_LongEphemeris.bin");
 JPL_DE.InitialiseDE_Ephemeris();
 return true;
 }
 
 internal static bool ReNameEphemerisToDEVersion(bool IsLongEphemFile)
 {
 string[] strArray = new string[8]
 {
 "",
 "a",
 "b",
 "c",
 "d",
 "e",
 "f",
 "g"
 };
 string str1 = JPL_DE.AppPath + "\\Resource Files\\";
 string str2 = str1 + "DE_Ephemeris.bin";
 string str3 = "";
 bool flag = false;
 if (IsLongEphemFile)
 str2 = str1 + "DE_LongEphemeris.bin";
 if (!File.Exists(str2))
 return true;
 char[] buffer = new char[80];
 string str4 = "";
 using (StreamReader streamReader = new StreamReader(str2))
 {
 streamReader.ReadBlock(buffer, 0, 80);
 string upper = new string(buffer, 20, 50).ToUpper();
 int startIndex = upper.IndexOf("DE");
 if (startIndex >= 0)
 str4 = upper.Substring(startIndex, 5);
 int num = upper.IndexOf("DE", startIndex + 1);
 if (num >= 0)
 str4 = str4 + "_" + upper.Substring(num + 2, 3);
 }
 for (int index = 0; index < strArray.Length; ++index)
 {
 str3 = str4 + strArray[index] + ".bin";
 flag = !File.Exists(str1 + str3);
 if (flag)
 break;
 }
 if (!flag | str3.Length < 1)
 return false;
 File.Move(str2, str1 + str3);
 return true;
 }
 
 internal static void PurgeLunarCache()
 {
 foreach (string file in Directory.GetFiles(JPL_DE.AppPath + "\\Resource Files\\Moon", "Moon*.bin"))
 File.Delete(file);
 }
 }
 }
 public class JPL_DE
 {
 private static int[] StartPointer = new int[13]
 {
 3,
 171,
 231,
 309,
 342,
 366,
 387,
 405,
 423,
 441,
 753,
 819,
 899
 };
 private static int[] NumOfCoeff = new int[13]
 {
 14,
 10,
 13,
 11,
 8,
 7,
 6,
 6,
 6,
 13,
 11,
 10,
 10
 };
 private static int[] NumOfIntervals = new int[13]
 {
 4,
 2,
 2,
 1,
 1,
 1,
 1,
 1,
 1,
 8,
 2,
 4,
 4
 };
 private static int[] Interval = new int[13]
 {
 8,
 16,
 16,
 32,
 32,
 32,
 32,
 32,
 32,
 4,
 16,
 8,
 8
 };
 public static string DE_Ephemeris_Version = "DE_Ephemeris.bin";
 internal static int EphemerisVersion = 0;
 internal static int LongEphemerisVersion = 0;
 public static string DE_LongEphemeris_Version = "DE_LongEphemeris.bin";
 internal static bool DE_EphemerisAvailable = false;
 internal static bool DE_LongEphemerisAvailable = false;
 public static double JDStart = 2305424.5;
 public static double JDEnd = 2525008.5;
 public static double JDStartLong = 2305424.5;
 public static double JDEndLong = 2525008.5;
 internal static bool Initialised = false;
 public static string AppPath;
 private const double AUkm = 149597870.7;
 private const double EarthMoonRatio = 81.3005690741906;
 private const double EarthFromBarycentre = 0.0121505842699404;
 private const double UnitLightTime = 0.0057756;
 public static Create_JPL_DE_EphemerisFile CreateDEfile;
 
 internal static void InitialiseDE_Ephemeris()
 {
 char[] buffer = new char[200];
 if (File.Exists(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_Ephemeris_Version))
 {
 using (StreamReader streamReader = new StreamReader(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_Ephemeris_Version))
 {
 streamReader.ReadBlock(buffer, 0, 200);
 string upper = new string(buffer, 0, 200).ToUpper();
 if (!int.TryParse(upper.Substring(upper.IndexOf("DE") + 2, 3), out JPL_DE.EphemerisVersion))
 JPL_DE.EphemerisVersion = 0;
 int num = upper.IndexOf("=");
 JPL_DE.JDStart = double.Parse(upper.Substring(num + 1, 11));
 JPL_DE.JDEnd = double.Parse(upper.Substring(upper.IndexOf("=", num + 1) + 1, 11));
 JPL_DE.DE_EphemerisAvailable = true;
 }
 }
 else
 {
 JPL_DE.JDStart = 0.0;
 JPL_DE.JDEnd = -1.0;
 JPL_DE.DE_EphemerisAvailable = false;
 }
 if (File.Exists(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_LongEphemeris_Version))
 {
 using (StreamReader streamReader = new StreamReader(JPL_DE.AppPath + "\\Resource Files\\" + JPL_DE.DE_LongEphemeris_Version))
 {
 streamReader.ReadBlock(buffer, 0, 200);
 string upper = new string(buffer, 0, 200).ToUpper();
 if (!int.TryParse(upper.Substring(upper.IndexOf("DE") + 2, 3), out JPL_DE.LongEphemerisVersion))
 JPL_DE.LongEphemerisVersion = 0;
 int num = upper.IndexOf("=");
 JPL_DE.JDStartLong = double.Parse(upper.Substring(num + 1, 11));
 JPL_DE.JDEndLong = double.Parse(upper.Substring(upper.IndexOf("=", num + 1) + 1, 11));
 JPL_DE.DE_LongEphemerisAvailable = true;
 }
 }
 else
 {
 JPL_DE.DE_LongEphemerisAvailable = false;
 JPL_DE.JDStartLong = 0.0;
 JPL_DE.JDEndLong = -1.0;
 }
 JPL_DE.Initialised = true;
 }
 
 public static void Show_CreateJPL_DE(int Tab)
 {
 Create_JPL_DE_EphemerisFile.OpeningTab = Tab;
 try
 {
 JPL_DE.CreateDEfile.Show();
 }
 catch
 {
 JPL_DE.CreateDEfile = new Create_JPL_DE_EphemerisFile();
 JPL_DE.CreateDEfile.Show();
 }
 }
 
 public static bool DE_Ephemeris(double JD, int Planet, out double x2000, out double y2000, out double z2000, out int Version)
 {
 if (!JPL_DE.Initialised)
 JPL_DE.InitialiseDE_Ephemeris();
 double[] numArray1 = new double[14];
 double[] numArray2 = new double[14];
 double[] numArray3 = new double[14];
 double[] numArray4 = new double[14];
 x2000 = y2000 = z2000 = (double) (Version = 0);
 if (Planet > 11 | Planet < 1)
 return false;
 string ephemerisVersion;
 long num1;
 double num2;
 if (JD >= JPL_DE.JDStart & JD < JPL_DE.JDEnd)
 {
 ephemerisVersion = JPL_DE.DE_Ephemeris_Version;
 Version = JPL_DE.EphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStart) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStart) % 32.0;
 }
 else
 {
 if (!(JD >= JPL_DE.JDStartLong & JD < JPL_DE.JDEndLong))
 return false;
 ephemerisVersion = JPL_DE.DE_LongEphemeris_Version;
 Version = JPL_DE.LongEphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStartLong) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStartLong) % 32.0;
 }
 FileStream fileStream = new FileStream(JPL_DE.AppPath + "\\Resource Files\\" + ephemerisVersion, FileMode.Open, FileAccess.Read);
 BinaryReader binaryReader = new BinaryReader((Stream) fileStream);
 int num3 = (int) num2 / JPL_DE.Interval[Planet - 1];
 int num4 = JPL_DE.NumOfCoeff[Planet - 1];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[Planet - 1] - 1)) + (long) (24 * JPL_DE.NumOfCoeff[Planet - 1] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray3[index] = binaryReader.ReadDouble();
 double num5 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[Planet - 1])) / (double) JPL_DE.Interval[Planet - 1]) - 1.0;
 double num6 = 2.0 * num5;
 numArray4[0] = 1.0;
 numArray4[1] = num5;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num6 * numArray4[index - 1] - numArray4[index - 2];
 double num7 = 0.0;
 double num8 = 0.0;
 double num9 = 0.0;
 for (int index = 0; index < num4; ++index)
 num7 += numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num8 += numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num9 += numArray3[index] * numArray4[index];
 if (Planet < 10)
 {
 num3 = (int) num2 / JPL_DE.Interval[10];
 num4 = JPL_DE.NumOfCoeff[10];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[10] - 1)) + (long) (24 * JPL_DE.NumOfCoeff[10] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray3[index] = binaryReader.ReadDouble();
 double num10 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[10])) / (double) JPL_DE.Interval[10]) - 1.0;
 double num11 = 2.0 * num10;
 numArray4[0] = 1.0;
 numArray4[1] = num10;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num11 * numArray4[index - 1] - numArray4[index - 2];
 for (int index = 0; index < num4; ++index)
 num7 -= numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num8 -= numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num9 -= numArray3[index] * numArray4[index];
 }
 if (Planet == 3)
 {
 num3 = (int) num2 / JPL_DE.Interval[9];
 num4 = JPL_DE.NumOfCoeff[9];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[9] - 1)) + (long) (24 * JPL_DE.NumOfCoeff[9] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 for (int index = 0; index < num4; ++index)
 numArray3[index] = binaryReader.ReadDouble();
 if (JPL_DE.Interval[9] != JPL_DE.Interval[Planet - 1])
 {
 double num10 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[9])) / (double) JPL_DE.Interval[9]) - 1.0;
 double num11 = 2.0 * num10;
 numArray4[0] = 1.0;
 numArray4[1] = num10;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num11 * numArray4[index - 1] - numArray4[index - 2];
 }
 for (int index = 0; index < num4; ++index)
 num7 -= 0.0121505842699404 * numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num8 -= 0.0121505842699404 * numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num9 -= 0.0121505842699404 * numArray3[index] * numArray4[index];
 }
 if (Planet == 10)
 {
 double num10 = Math.Sqrt(num7 * num7 + num8 * num8 + num9 * num9) / 149597870.7 * 0.0057756;
 double num11 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[Planet - 1]) - num10) / (double) JPL_DE.Interval[Planet - 1]) - 1.0;
 double num12 = 2.0 * num11;
 numArray4[0] = 1.0;
 numArray4[1] = num11;
 for (int index = 2; index < num4; ++index)
 numArray4[index] = num12 * numArray4[index - 1] - numArray4[index - 2];
 double num13;
 double num14 = num13 = 0.0;
 double num15 = num13;
 double num16 = num13;
 for (int index = 0; index < num4; ++index)
 num16 += numArray1[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num15 += numArray2[index] * numArray4[index];
 for (int index = 0; index < num4; ++index)
 num14 += numArray3[index] * numArray4[index];
 x2000 = num16;
 y2000 = num15;
 z2000 = num14;
 }
 else
 {
 x2000 = num7 / 149597870.7;
 y2000 = num8 / 149597870.7;
 z2000 = num9 / 149597870.7;
 }
 fileStream.Close();
 return true;
 }
 
 public static bool DE_Nutation(double JD, out double NutL, out double NutE, out int Version)
 {
 if (!JPL_DE.Initialised)
 JPL_DE.InitialiseDE_Ephemeris();
 double[] numArray1 = new double[14];
 double[] numArray2 = new double[14];
 double[] numArray3 = new double[14];
 NutL = NutE = (double) (Version = 0);
 string ephemerisVersion;
 long num1;
 double num2;
 if (JD >= JPL_DE.JDStart & JD < JPL_DE.JDEnd)
 {
 ephemerisVersion = JPL_DE.DE_Ephemeris_Version;
 Version = JPL_DE.EphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStart) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStart) % 32.0;
 }
 else
 {
 if (!(JD >= JPL_DE.JDStartLong & JD < JPL_DE.JDEndLong))
 return false;
 ephemerisVersion = JPL_DE.DE_LongEphemeris_Version;
 Version = JPL_DE.LongEphemerisVersion;
 num1 = (long) (int) (Math.Floor((JD - JPL_DE.JDStartLong) / 32.0) + 2.0) * 1018L * 8L;
 num2 = (JD - JPL_DE.JDStartLong) % 32.0;
 }
 FileStream fileStream = new FileStream(JPL_DE.AppPath + "\\Resource Files\\" + ephemerisVersion, FileMode.Open, FileAccess.Read);
 BinaryReader binaryReader = new BinaryReader((Stream) fileStream);
 int num3 = (int) num2 / JPL_DE.Interval[11];
 int num4 = JPL_DE.NumOfCoeff[11];
 fileStream.Seek(num1 + (long) (8 * (JPL_DE.StartPointer[11] - 1)) + (long) (16 * JPL_DE.NumOfCoeff[11] * num3), SeekOrigin.Begin);
 for (int index = 0; index < num4; ++index)
 numArray1[index] = binaryReader.ReadDouble();
 if (numArray1[0] == 0.0 & numArray1[1] == 0.0)
 return false;
 for (int index = 0; index < num4; ++index)
 numArray2[index] = binaryReader.ReadDouble();
 double num5 = 2.0 * ((num2 - (double) (num3 * JPL_DE.Interval[11])) / (double) JPL_DE.Interval[11]) - 1.0;
 double num6 = 2.0 * num5;
 numArray3[0] = 1.0;
 numArray3[1] = num5;
 for (int index = 2; index < num4; ++index)
 numArray3[index] = num6 * numArray3[index - 1] - numArray3[index - 2];
 for (int index = 0; index < num4; ++index)
 NutL += numArray1[index] * numArray3[index];
 for (int index = 0; index < num4; ++index)
 NutE += numArray2[index] * numArray3[index];
 return true;
 }
 
 internal static string GetDE_VersionDetails(string DE_Version)
 {
 string Version;
 string Years;
 JPL_DE.GetDE_VersionDetails(DE_Version, out Version, out Years);
 return Version + " " + Years;
 }
 
 internal static void GetDE_VersionDetails(string DE_Version, out string Version, out string Years)
 {
 Years = "(?/?)";
 Version = "?";
 if (DE_Version.Length < 1)
 return;
 using (StreamReader streamReader = new StreamReader(JPL_DE.AppPath + "\\Resource Files\\" + DE_Version))
 {
 char[] buffer = new char[256];
 streamReader.Read(buffer, 0, 256);
 string str = new string(buffer);
 int startIndex = str.IndexOf("DE");
 if (startIndex >= 0)
 {
 Version = str.Substring(startIndex, 5);
 int num = str.IndexOf("DE", startIndex + 2);
 if (num >= 0 & num < 80)
 Version = Version + "," + str.Substring(num + 2, 3);
 }
 else
 Version = "???";
 Years = "(" + (JPL_DE.ExtractYear(str.Substring(84, 80)) + 1).ToString() + "/" + JPL_DE.ExtractYear(str.Substring(168, 80)).ToString() + ")";
 }
 }
 
 private static int ExtractYear(string Ln)
 {
 int startIndex = Ln.IndexOf(".") + 2;
 int num = Ln.IndexOf(" ", startIndex + 1);
 if (num - startIndex > 8)
 num = Ln.IndexOf("-", startIndex + 1);
 int result;
 if (!int.TryParse(Ln.Substring(startIndex, num - startIndex), out result))
 result = 0;
 return result;
 }
 
 internal static bool Set_DE_EphemerisFile(string DE_File)
 {
 if (!JPL_DE.ReNameEphemerisToDEVersion(false))
 {
 int num = (int) MessageBox.Show("Can't rename the current DE_Ephemeris file\r\n\r\nTherefore cannot set a new file for the DE_LongEphemeris", "Can't rename", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
 return false;
 }
 File.Move(JPL_DE.AppPath + "\\Resource Files\\" + DE_File, JPL_DE.AppPath + "\\Resource Files\\DE_Ephemeris.bin");
 JPL_DE.InitialiseDE_Ephemeris();
 return true;
 }
 
 internal static bool Set_DE_LongEphemerisFile(string DE_File)
 {
 if (!JPL_DE.ReNameEphemerisToDEVersion(true))
 {
 int num = (int) MessageBox.Show("Can't rename the current DE_LongEphemeris file\r\n\r\nTherefore cannot set a new file for the DE_LongEphemeris", "Can't rename", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
 return false;
 }
 File.Move(JPL_DE.AppPath + "\\Resource Files\\" + DE_File, JPL_DE.AppPath + "\\Resource Files\\DE_LongEphemeris.bin");
 JPL_DE.InitialiseDE_Ephemeris();
 return true;
 }
 
 internal static bool ReNameEphemerisToDEVersion(bool IsLongEphemFile)
 {
 string[] strArray = new string[8]
 {
 "",
 "a",
 "b",
 "c",
 "d",
 "e",
 "f",
 "g"
 };
 string str1 = JPL_DE.AppPath + "\\Resource Files\\";
 string str2 = str1 + "DE_Ephemeris.bin";
 string str3 = "";
 bool flag = false;
 if (IsLongEphemFile)
 str2 = str1 + "DE_LongEphemeris.bin";
 if (!File.Exists(str2))
 return true;
 char[] buffer = new char[80];
 string str4 = "";
 using (StreamReader streamReader = new StreamReader(str2))
 {
 streamReader.ReadBlock(buffer, 0, 80);
 string upper = new string(buffer, 20, 50).ToUpper();
 int startIndex = upper.IndexOf("DE");
 if (startIndex >= 0)
 str4 = upper.Substring(startIndex, 5);
 int num = upper.IndexOf("DE", startIndex + 1);
 if (num >= 0)
 str4 = str4 + "_" + upper.Substring(num + 2, 3);
 }
 for (int index = 0; index < strArray.Length; ++index)
 {
 str3 = str4 + strArray[index] + ".bin";
 flag = !File.Exists(str1 + str3);
 if (flag)
 break;
 }
 if (!flag | str3.Length < 1)
 return false;
 File.Move(str2, str1 + str3);
 return true;
 }
 
 internal static void PurgeLunarCache()
 {
 foreach (string file in Directory.GetFiles(JPL_DE.AppPath + "\\Resource Files\\Moon", "Moon*.bin"))
 File.Delete(file);
 }
 }
 }

 
 
 ***/
