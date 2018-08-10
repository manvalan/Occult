//
//  JPLDE_CreateFile.swift
//  Occult
//
//  Created by Michele Bigi on 27/05/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class JPLDE_CreateFile{
    func fileClose( fh : FileHandle )  {
        fh.closeFile()
    }
    
    func writeBin( fh :FileHandle , data : Data ) {
        fh.seekToEndOfFile()
        fh.write( data )
    }
    
    func fileBinOpenWrite( path: String )->FileHandle {
        let fh = FileHandle(forWritingAtPath: path)
        
        return fh!
    }
    
    func CreateFile() {
        var numArray : [ Double ] = Array( repeating: 0,count: 1021 )
       
        /*
        this.panelPBar.Visible = true;
        FileStream fileStream1 = new FileStream(Utilities.AppPath + "\\Resource Files\\DE" + Create_JPL_DE_EphemerisFile.Version + ".bin", FileMode.Create, FileAccess.Write);
         
        BinaryWriter binaryWriter = new BinaryWriter((Stream) fileStream1);
        StreamWriter streamWriter = new StreamWriter((Stream) new FileStream(Create_JPL_DE_EphemerisFile.SourcePath + "\\" + Create_JPL_DE_EphemerisFile.Version + ".log", FileMode.Create, FileAccess.Write));
        using (StreamReader streamReader = new StreamReader(Create_JPL_DE_EphemerisFile.SourceHeader))
        {
            string str1 = streamReader.ReadLine();
            str1 = streamReader.ReadLine();
            str1 = streamReader.ReadLine();
            str1 = streamReader.ReadLine();
            char[] charArray1 = streamReader.ReadLine().PadRight(84).ToCharArray();
            binaryWriter.Write(charArray1, 0, 84);
            char[] charArray2 = Create_JPL_DE_EphemerisFile.HeaderStartLine.PadRight(84).ToCharArray();
            binaryWriter.Write(charArray2, 0, 84);
            char[] charArray3 = Create_JPL_DE_EphemerisFile.HeaderEndLine.PadRight(84).ToCharArray();
            binaryWriter.Write(charArray3, 0, 84);
            for (int index = 0; index <= 7; ++index)
            str1 = streamReader.ReadLine();
            for (int index1 = 0; index1 < 16; ++index1)
            {
                string str2 = streamReader.ReadLine();
                for (int index2 = 0; index2 < 10; ++index2)
                {
                    char[] charArray4 = str2.PadRight(80).Substring(2 + 8 * index2, 6).ToCharArray();
                    binaryWriter.Write(charArray4, 0, 6);
                }
            }
        }
        fileStream1.Seek(16288L, SeekOrigin.Begin);
        double num1 = -4000000.0;
        for (int index1 = 0; index1 < Create_JPL_DE_EphemerisFile.Sources.Count; ++index1)
        {
            Application.DoEvents();
            if (Create_JPL_DE_EphemerisFile.Sources[index1].ToBeUsed)
            {
                this.lblFileProcessing.Text = Create_JPL_DE_EphemerisFile.Sources[index1].FileName.ToString();
                FileStream fileStream2 = new FileStream(Create_JPL_DE_EphemerisFile.Sources[index1].File.ToString(), FileMode.Open, FileAccess.Read);
                long length = fileStream2.Length;
                StreamReader streamReader = new StreamReader((Stream) fileStream2);
                this.pBarBlock.Minimum = 1;
                this.pBarBlock.Value = 1;
                this.pBarBlock.Maximum = (int) (fileStream2.Length / (long) Create_JPL_DE_EphemerisFile.SourceBlockLength);
                do
                {
                    int num2 = int.Parse(streamReader.ReadLine().Substring(0, 7));
                    if (num2 % 10 == 0)
                    this.pBarBlock.Value = num2;
                    Application.DoEvents();
                    int index2 = 1;
                    while (index2 <= Create_JPL_DE_EphemerisFile.NCoeff)
                    {
                        string str = streamReader.ReadLine().Replace("D", "E");
                        numArray[index2] = double.Parse(str.Substring(0, 26));
                        try
                    {
                        numArray[index2 + 1] = double.Parse(str.Substring(26, 26));
                        }
                        catch
                        {
                        numArray[index2 + 1] = 0.0;
                        }
                        try
                    {
                        numArray[index2 + 2] = double.Parse(str.Substring(52, 26));
                        }
                        catch
                        {
                        numArray[index2 + 2] = 0.0;
                        }
                        index2 += 3;
                    }
                    if (numArray[1] > num1)
                    {
                        streamWriter.WriteLine(numArray[1]);
                        num1 = numArray[1];
                        for (int index3 = 1; index3 <= Create_JPL_DE_EphemerisFile.NCoeff; ++index3)
                        {
                            if (index3 == 819 & Create_JPL_DE_EphemerisFile.NoNutations)
                            {
                                for (int index4 = 0; index4 < 80; ++index4)
                                binaryWriter.Write(0.0);
                            }
                            binaryWriter.Write(numArray[index3]);
                        }
                    }
                }
                    while (!streamReader.EndOfStream);
                streamReader.Close();
                this.listViewFiles.Items[index1 + 1].ForeColor = Color.Brown;
                Application.DoEvents();
            }
        }
        long position = fileStream1.Position;
        fileStream1.Close();
        streamWriter.Close();
        this.panelPBar.Visible = false;
        this.CheckLogFile();
 */
    }
}
/*****

public class Create_JPL_DE_EphemerisFile : Form
{
    internal static int OpeningTab = 0;
    private static int SourceBlockLength = 26873;
    private static bool NoNutations = false;
    private static int NCoeff = 0;
    private static string HeaderStartLine = "";
    private static string HeaderEndLine = "";
    private static string Version = "";
    private static bool FilesAreContinuous = true;
    private static string DownloadVersion = "";
    private static string ProposedDEFile = "";
    private static string ProposedDefaultFile = "";
    internal static List<DESourceFiles> Sources = new List<DESourceFiles>();
    private static string SourceFileFolder;
    private static string SourceHeader;
    private static string SourcePath;
    private DESourceFiles SourceFile;
    private IContainer components;
    private Button cmdSelectDEfolder;
    private Label lblSource;
    private Label lblHeader;
    private Button cmdCreateDEfile;
    private ProgressBar pBarBlock;
    private Panel panelPBar;
    private Label label2;
    private Label label4;
    private Label lblContinuity;
    private MenuStrip menuStrip1;
    private ToolStripMenuItem helpToolStripMenuItem;
    private ToolStripMenuItem exitToolStripMenuItem;
    private TabControl tabControl1;
    private TabPage tabDownload;
    private TabPage tabConvert;
    private ListBox lstVersions;
    private Button cmdListVersions;
    private Label label5;
    private Label lblFiles;
    private Button cmdDownload;
    private Label label6;
    private Label lblFile;
    private Panel panelProcessing;
    private ListView listViewDownload;
    private ListView listViewFiles;
    private Label lblFileProcessing;
    private ToolTip toolTip1;
    private Label label7;
    private Label label3;
    private Label label1;
    private Label label8;
    private TabPage tabDefaults;
    private TabPage tabSetTemporary;
    private Label label9;
    private ListView listViewDEfiles;
    private Label LBLCurrentVersion;
    private Label label10;
    private Label lblLabel11;
    private Label lblDEproposed;
    private Button cmdUseSelectDEfile;
    private Label label11;
    private Button cmdClose;
    private Label label12;
    private ListView listViewDEfilesForDefaults;
    private GroupBox grpSetDE_Long;
    private Label label14;
    private GroupBox grpSetDEEphemeris;
    private Label label13;
    private Label lblCurrentDE_Long;
    private Label lblCurrentDE_Ephem;
    private Label lblProposedDefault;
    private Button cmdSetDE_Long;
    private Button cmdSetDE_Ephemeris;
    private Label label15;
    private Button cmdCancelDownload;
    
    public Create_JPL_DE_EphemerisFile()
{
    this.InitializeComponent();
    }
    
    private void Create_JPL_DE_EphemerisFile_Load(object sender, EventArgs e)
{
    this.Text = this.Text + " : Occult v." + Utilities.OccultVersion_Short;
    this.cmdCancelDownload.Location = this.cmdDownload.Location;
    Create_JPL_DE_EphemerisFile.SourceFileFolder = Utilities.AppPath + "\\DownLoaded Files\\DE_SourceFiles";
    this.tabControl1.SelectedIndex = Create_JPL_DE_EphemerisFile.OpeningTab;
    }
    
    private void cmdCreateDEfile_Click(object sender, EventArgs e)
{
    if (Create_JPL_DE_EphemerisFile.Sources.Count < 1)
    return;
    this.CreateFile();
    }
    
    private void CreateFile()
{
    double[] numArray = new double[1021];
    this.panelPBar.Visible = true;
    FileStream fileStream1 = new FileStream(Utilities.AppPath + "\\Resource Files\\DE" + Create_JPL_DE_EphemerisFile.Version + ".bin", FileMode.Create, FileAccess.Write);
    BinaryWriter binaryWriter = new BinaryWriter((Stream) fileStream1);
    StreamWriter streamWriter = new StreamWriter((Stream) new FileStream(Create_JPL_DE_EphemerisFile.SourcePath + "\\" + Create_JPL_DE_EphemerisFile.Version + ".log", FileMode.Create, FileAccess.Write));
    using (StreamReader streamReader = new StreamReader(Create_JPL_DE_EphemerisFile.SourceHeader))
    {
    string str1 = streamReader.ReadLine();
    str1 = streamReader.ReadLine();
    str1 = streamReader.ReadLine();
    str1 = streamReader.ReadLine();
    char[] charArray1 = streamReader.ReadLine().PadRight(84).ToCharArray();
    binaryWriter.Write(charArray1, 0, 84);
    char[] charArray2 = Create_JPL_DE_EphemerisFile.HeaderStartLine.PadRight(84).ToCharArray();
    binaryWriter.Write(charArray2, 0, 84);
    char[] charArray3 = Create_JPL_DE_EphemerisFile.HeaderEndLine.PadRight(84).ToCharArray();
    binaryWriter.Write(charArray3, 0, 84);
    for (int index = 0; index <= 7; ++index)
    str1 = streamReader.ReadLine();
    for (int index1 = 0; index1 < 16; ++index1)
    {
    string str2 = streamReader.ReadLine();
    for (int index2 = 0; index2 < 10; ++index2)
    {
    char[] charArray4 = str2.PadRight(80).Substring(2 + 8 * index2, 6).ToCharArray();
    binaryWriter.Write(charArray4, 0, 6);
    }
    }
    }
    fileStream1.Seek(16288L, SeekOrigin.Begin);
    double num1 = -4000000.0;
    for (int index1 = 0; index1 < Create_JPL_DE_EphemerisFile.Sources.Count; ++index1)
    {
    Application.DoEvents();
    if (Create_JPL_DE_EphemerisFile.Sources[index1].ToBeUsed)
    {
    this.lblFileProcessing.Text = Create_JPL_DE_EphemerisFile.Sources[index1].FileName.ToString();
    FileStream fileStream2 = new FileStream(Create_JPL_DE_EphemerisFile.Sources[index1].File.ToString(), FileMode.Open, FileAccess.Read);
    long length = fileStream2.Length;
    StreamReader streamReader = new StreamReader((Stream) fileStream2);
    this.pBarBlock.Minimum = 1;
    this.pBarBlock.Value = 1;
    this.pBarBlock.Maximum = (int) (fileStream2.Length / (long) Create_JPL_DE_EphemerisFile.SourceBlockLength);
    do
    {
    int num2 = int.Parse(streamReader.ReadLine().Substring(0, 7));
    if (num2 % 10 == 0)
    this.pBarBlock.Value = num2;
    Application.DoEvents();
    int index2 = 1;
    while (index2 <= Create_JPL_DE_EphemerisFile.NCoeff)
    {
    string str = streamReader.ReadLine().Replace("D", "E");
    numArray[index2] = double.Parse(str.Substring(0, 26));
    try
{
    numArray[index2 + 1] = double.Parse(str.Substring(26, 26));
    }
    catch
    {
    numArray[index2 + 1] = 0.0;
    }
    try
{
    numArray[index2 + 2] = double.Parse(str.Substring(52, 26));
    }
    catch
    {
    numArray[index2 + 2] = 0.0;
    }
    index2 += 3;
    }
    if (numArray[1] > num1)
    {
    streamWriter.WriteLine(numArray[1]);
    num1 = numArray[1];
    for (int index3 = 1; index3 <= Create_JPL_DE_EphemerisFile.NCoeff; ++index3)
    {
    if (index3 == 819 & Create_JPL_DE_EphemerisFile.NoNutations)
    {
    for (int index4 = 0; index4 < 80; ++index4)
    binaryWriter.Write(0.0);
    }
    binaryWriter.Write(numArray[index3]);
    }
    }
    }
    while (!streamReader.EndOfStream);
    streamReader.Close();
    this.listViewFiles.Items[index1 + 1].ForeColor = Color.Brown;
    Application.DoEvents();
    }
    }
    long position = fileStream1.Position;
    fileStream1.Close();
    streamWriter.Close();
    this.panelPBar.Visible = false;
    this.CheckLogFile();
    }
    
    private void CheckLogFile()
{
    FileStream fileStream = new FileStream(Create_JPL_DE_EphemerisFile.SourcePath + "\\" + Create_JPL_DE_EphemerisFile.Version + ".log", FileMode.Open, FileAccess.Read);
    StreamReader streamReader = new StreamReader((Stream) fileStream);
    int num1 = 0;
    double num2 = double.Parse(streamReader.ReadLine());
    do
    {
    double num3 = double.Parse(streamReader.ReadLine());
    if (num3 - num2 != 32.0)
    {
    int num4 = (int) MessageBox.Show("Log file problem at " + num3.ToString());
    ++num1;
    }
    num2 = num3;
    }
    while (!streamReader.EndOfStream);
    fileStream.Close();
    int num5 = (int) MessageBox.Show("DE" + Create_JPL_DE_EphemerisFile.Version + ".bin file created.\r\n\r\nLog file checked, with " + num1.ToString() + " errors", "DE" + Create_JPL_DE_EphemerisFile.Version + ".bin  log file check");
    }
    
    private void cmdSelectDEfolder_Click(object sender, EventArgs e)
{
    string str1 = "";
    bool flag = false;
    FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
    folderBrowserDialog.ShowNewFolderButton = false;
    folderBrowserDialog.SelectedPath = Create_JPL_DE_EphemerisFile.SourceFileFolder;
    folderBrowserDialog.Description = "Select folder containing JPL-DE source files";
    if (folderBrowserDialog.ShowDialog() != DialogResult.OK)
    return;
    Create_JPL_DE_EphemerisFile.SourceFileFolder = folderBrowserDialog.SelectedPath;
    Create_JPL_DE_EphemerisFile.SourceHeader = "";
    this.lblSource.Text = "Source file folder = " + Create_JPL_DE_EphemerisFile.SourceFileFolder;
    Create_JPL_DE_EphemerisFile.Sources.Clear();
    this.listViewFiles.Items.Clear();
    this.listViewFiles.Items.Add("File name       Start Date       End Date");
    this.listViewFiles.Items[0].Checked = false;
    this.listViewFiles.Items[0].ForeColor = Color.DarkBlue;
    foreach (string file in Directory.GetFiles(Create_JPL_DE_EphemerisFile.SourceFileFolder))
    {
    int result;
    if (!int.TryParse(Path.GetExtension(file).Replace(".", "").PadRight(3).Substring(0, 3), out result))
    result = 0;
    if (result != 0)
    {
    string withoutExtension = Path.GetFileNameWithoutExtension(file);
    if (withoutExtension.ToLower().Contains("header") & !flag)
    {
    Create_JPL_DE_EphemerisFile.SourceHeader = file;
    this.lblHeader.Text = "Header file = " + Path.GetFileName(file);
    flag = true;
    }
    else if (withoutExtension.ToLower().PadRight(3).Substring(0, 3).Contains("asc"))
    {
    if (str1.Length == 0)
    {
    str1 = Path.GetExtension(file);
    Create_JPL_DE_EphemerisFile.SourcePath = Path.GetDirectoryName(file);
    Create_JPL_DE_EphemerisFile.Version = str1.Replace(".", "");
    }
    this.SourceFile = new DESourceFiles();
    this.SourceFile.File = file;
    this.SourceFile.FileName = Path.GetFileName(file);
    using (StreamReader streamReader = new StreamReader(file))
    {
    streamReader.ReadLine();
    this.SourceFile.StartJD = double.Parse(streamReader.ReadLine().Replace("D", "E").Substring(0, 26));
    }
    Create_JPL_DE_EphemerisFile.Sources.Add(this.SourceFile);
    }
    }
    }
    Create_JPL_DE_EphemerisFile.Sources.Sort();
    if (Create_JPL_DE_EphemerisFile.SourceHeader == "")
    {
    int num1 = (int) MessageBox.Show("No header file found. Conversion cannot proceed", "No Header file", MessageBoxButtons.OK);
    }
    else
    {
    using (StreamReader streamReader = new StreamReader(Create_JPL_DE_EphemerisFile.SourceHeader))
    {
    string str2 = streamReader.ReadLine();
    int startIndex = str2.IndexOf("NCOEFF=") + 7;
    Create_JPL_DE_EphemerisFile.SourceBlockLength = 26873;
    if (!int.TryParse(str2.Substring(startIndex), out Create_JPL_DE_EphemerisFile.NCoeff))
    Create_JPL_DE_EphemerisFile.NCoeff = 0;
    switch (Create_JPL_DE_EphemerisFile.NCoeff)
    {
    case 938:
    Create_JPL_DE_EphemerisFile.NoNutations = true;
    Create_JPL_DE_EphemerisFile.SourceBlockLength = 24714;
    break;
    case 1018:
    Create_JPL_DE_EphemerisFile.NoNutations = false;
    Create_JPL_DE_EphemerisFile.SourceBlockLength = 26873;
    if (new FileInfo(Create_JPL_DE_EphemerisFile.Sources[0].File).Length % (long) Create_JPL_DE_EphemerisFile.SourceBlockLength != 0L)
    {
    Create_JPL_DE_EphemerisFile.SourceBlockLength = 26821;
    break;
    }
    break;
    default:
    int num2 = (int) MessageBox.Show("Source files are incompatible with this conversion routine. Conversion will not proceed", "Incompatible files", MessageBoxButtons.OK);
    return;
    }
    }
    for (int index = 0; index < Create_JPL_DE_EphemerisFile.Sources.Count; ++index)
    {
    Create_JPL_DE_EphemerisFile.Sources[index].EndJD = Create_JPL_DE_EphemerisFile.Sources[index].StartJD + (double) (new FileInfo(Create_JPL_DE_EphemerisFile.Sources[index].File).Length / (long) Create_JPL_DE_EphemerisFile.SourceBlockLength * 32L);
    this.listViewFiles.Items.Add(Create_JPL_DE_EphemerisFile.Sources[index].ToString());
    this.listViewFiles.Items[index + 1].Checked = true;
    this.listViewFiles.Items[index + 1].ForeColor = Color.Green;
    if (index > 0)
    Create_JPL_DE_EphemerisFile.FilesAreContinuous &= Create_JPL_DE_EphemerisFile.Sources[index].StartJD <= Create_JPL_DE_EphemerisFile.Sources[index - 1].EndJD;
    }
    this.GetCheckRange();
    }
    }
    
    private void listViewFiles_Click(object sender, EventArgs e)
{
    try
{
    int selectedIndex = this.listViewFiles.SelectedIndices[0];
    if (selectedIndex > 0 & selectedIndex <= Create_JPL_DE_EphemerisFile.Sources.Count)
    {
    Create_JPL_DE_EphemerisFile.Sources[selectedIndex - 1].ToBeUsed = !Create_JPL_DE_EphemerisFile.Sources[selectedIndex - 1].ToBeUsed;
    for (int index = 0; index < Create_JPL_DE_EphemerisFile.Sources.Count; ++index)
    {
    this.listViewFiles.Items[index + 1].Checked = Create_JPL_DE_EphemerisFile.Sources[index].ToBeUsed;
    this.listViewFiles.Items[index + 1].ForeColor = !Create_JPL_DE_EphemerisFile.Sources[index].ToBeUsed ? Color.OrangeRed : Color.Green;
    }
    }
    this.GetCheckRange();
    }
    catch
    {
    }
    }
    
    private void GetCheckRange()
{
    int index1 = 0;
    int index2 = 0;
    for (int index3 = 0; index3 < Create_JPL_DE_EphemerisFile.Sources.Count; ++index3)
    {
    if (Create_JPL_DE_EphemerisFile.Sources[index3].ToBeUsed)
    {
    index1 = index3;
    break;
    }
    }
    for (int index3 = Create_JPL_DE_EphemerisFile.Sources.Count - 1; index3 >= 0; --index3)
    {
    if (Create_JPL_DE_EphemerisFile.Sources[index3].ToBeUsed)
    {
    index2 = index3;
    break;
    }
    }
    Create_JPL_DE_EphemerisFile.HeaderStartLine = "Start Epoch: JED=" + string.Format("{0,11:f1}", (object) Create_JPL_DE_EphemerisFile.Sources[index1].StartJD) + " " + Utilities.Date_from_JD(Create_JPL_DE_EphemerisFile.Sources[index1].StartJD, 0, false) + " 00:00:00";
    Create_JPL_DE_EphemerisFile.HeaderEndLine = "Final Epoch: JED=" + string.Format("{0,11:f1}", (object) Create_JPL_DE_EphemerisFile.Sources[index2].EndJD) + " " + Utilities.Date_from_JD(Create_JPL_DE_EphemerisFile.Sources[index2].EndJD, 0, false) + " 00:00:00";
    Create_JPL_DE_EphemerisFile.FilesAreContinuous = true;
    for (int index3 = index1 + 1; index3 <= index2; ++index3)
    {
    if (index3 > 0)
    Create_JPL_DE_EphemerisFile.FilesAreContinuous = Create_JPL_DE_EphemerisFile.FilesAreContinuous & Create_JPL_DE_EphemerisFile.Sources[index3].StartJD <= Create_JPL_DE_EphemerisFile.Sources[index3 - 1].EndJD & Create_JPL_DE_EphemerisFile.Sources[index3].ToBeUsed;
    }
    if (Create_JPL_DE_EphemerisFile.FilesAreContinuous)
    {
    this.lblContinuity.ForeColor = Color.DarkGreen;
    this.lblContinuity.Text = "Files provide continuous coverage";
    }
    else
    {
    this.lblContinuity.ForeColor = Color.DarkRed;
    this.lblContinuity.Text = "Files have gaps in the range covered. Conversion cannot proceed.";
    }
    this.cmdCreateDEfile.Enabled = Create_JPL_DE_EphemerisFile.FilesAreContinuous;
    this.cmdCreateDEfile.Text = "Create  DE" + Create_JPL_DE_EphemerisFile.Version + ".bin  file";
    }
    
    private void exitToolStripMenuItem_Click(object sender, EventArgs e)
{
    this.Close();
    this.Dispose();
    }
    
    private void helpToolStripMenuItem_Click(object sender, EventArgs e)
{
    Help.ShowHelp((Control) this, Utilities.AppPath + "\\Occult.chm", HelpNavigator.KeywordIndex, (object) "JPL-DE Conversion");
    }
    
    private void cmdListVersions_Click(object sender, EventArgs e)
{
    if (!NetworkInterface.GetIsNetworkAvailable())
    return;
    if (Settings.Default.FTP_AnonymousPassword.Length < 4)
    {
    if (MessageBox.Show("You must specify your Email address for anonymous FTP", "No email address", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation) == DialogResult.Cancel)
    return;
    Defaults defaults = new Defaults();
    defaults.FTPPassword.Focus();
    int num = (int) defaults.ShowDialog();
    }
    if (Settings.Default.FTP_AnonymousPassword.Length < 4)
    return;
    Cursor.Current = Cursors.WaitCursor;
    this.lstVersions.Items.Clear();
    string anonymousPassword = Settings.Default.FTP_AnonymousPassword;
    FtpWebRequest ftpWebRequest = (FtpWebRequest) WebRequest.Create("ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/");
    ftpWebRequest.Method = "LIST";
    ftpWebRequest.Credentials = (ICredentials) new NetworkCredential("anonymous", anonymousPassword);
    string[] strArray;
    try
{
    FtpWebResponse response = (FtpWebResponse) ftpWebRequest.GetResponse();
    StreamReader streamReader = new StreamReader(response.GetResponseStream());
    strArray = streamReader.ReadToEnd().Split('\n');
    streamReader.Close();
    response.Close();
    }
    catch
    {
    Cursor.Current = Cursors.Default;
    return;
    }
    Cursor.Current = Cursors.Default;
    for (int index = strArray.Length - 1; index >= 0; --index)
    {
    if (strArray[index].Length >= 20 && !(strArray[index].Substring(0, 1) != "d"))
    {
    int startIndex = strArray[index].LastIndexOf(" ");
    string str = strArray[index].Substring(startIndex).Trim();
    if (!str.EndsWith("t"))
    this.lstVersions.Items.Add((object) str);
    }
    }
    }
    
    private void lstVersions_DoubleClick(object sender, EventArgs e)
{
    if (!NetworkInterface.GetIsNetworkAvailable())
    return;
    if (Settings.Default.FTP_AnonymousPassword.Length < 4)
    {
    if (MessageBox.Show("You must specify your Email address for anonymous FTP", "No email address", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation) == DialogResult.Cancel)
    return;
    Defaults defaults = new Defaults();
    defaults.FTPPassword.Focus();
    int num = (int) defaults.ShowDialog();
    }
    if (Settings.Default.FTP_AnonymousPassword.Length < 4)
    return;
    Cursor.Current = Cursors.WaitCursor;
    string anonymousPassword = Settings.Default.FTP_AnonymousPassword;
    Create_JPL_DE_EphemerisFile.DownloadVersion = this.lstVersions.Items[this.lstVersions.SelectedIndex].ToString();
    this.lblFiles.Text = "Files for " + Create_JPL_DE_EphemerisFile.DownloadVersion.ToUpper();
    FtpWebRequest ftpWebRequest = (FtpWebRequest) WebRequest.Create("ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/" + Create_JPL_DE_EphemerisFile.DownloadVersion + "/");
    ftpWebRequest.Method = "LIST";
    ftpWebRequest.Credentials = (ICredentials) new NetworkCredential("anonymous", anonymousPassword);
    this.listViewDownload.Items.Clear();
    string[] strArray;
    try
{
    FtpWebResponse response = (FtpWebResponse) ftpWebRequest.GetResponse();
    StreamReader streamReader = new StreamReader(response.GetResponseStream());
    strArray = streamReader.ReadToEnd().Split('\n');
    streamReader.Close();
    response.Close();
    }
    catch
    {
    Cursor.Current = Cursors.Default;
    return;
    }
    for (int index = 0; index < strArray.Length; ++index)
    {
    if (strArray[index].Length >= 20)
    {
    int startIndex = strArray[index].LastIndexOf(" ");
    string str1 = strArray[index].Substring(startIndex).Trim();
    long result;
    if (!long.TryParse(strArray[index].Substring(33, 10), out result))
    result = 0L;
    string str2 = result <= 500000L ? string.Format(" [{0,5:f1} kb]", (object) ((double) result / 1024.0)) : string.Format(" [{0,5:f1} MB]", (object) ((double) result / 1048576.0));
    this.listViewDownload.Items.Add(str1.PadRight(14) + str2);
    string str3 = Utilities.AppPath + "\\Downloaded Files\\DE_SourceFiles\\" + Create_JPL_DE_EphemerisFile.DownloadVersion.ToUpper() + "\\" + str1;
    bool flag1 = false;
    bool flag2 = System.IO.File.Exists(str3);
    if (flag2)
    flag1 = new FileInfo(str3).Length == result;
    this.listViewDownload.Items[index].Checked = !flag1;
    this.listViewDownload.Items[index].ForeColor = !flag1 ? (!flag2 ? Color.Black : Color.DarkOrange) : Color.DarkGreen;
    }
    }
    }
    
    private void cmdDownload_Click(object sender, EventArgs e)
{
    string str = Utilities.AppPath + "\\Downloaded Files\\DE_SourceFiles\\" + Create_JPL_DE_EphemerisFile.DownloadVersion.ToUpper() + "\\";
    if (!Directory.Exists(str))
    Directory.CreateDirectory(str);
    ftp.CancelFlag = false;
    this.cmdCancelDownload.Visible = true;
    this.panelProcessing.Visible = true;
    for (int index = 0; index < this.listViewDownload.Items.Count; ++index)
    {
    if (this.listViewDownload.Items[index].Checked)
    {
    string FileName;
    this.lblFile.Text = FileName = this.listViewDownload.Items[index].Text.ToString().Substring(0, 14).Trim();
    if (ftp.DownloadFTP("ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/" + Create_JPL_DE_EphemerisFile.DownloadVersion + "/", FileName, str, false, false, true))
    {
    this.listViewDownload.Items[index].ForeColor = Color.Green;
    this.listViewDownload.Items[index].Checked = false;
    }
    else
    this.listViewDownload.Items[index].ForeColor = Color.Red;
    Application.DoEvents();
    if (ftp.CancelFlag)
    break;
    }
    }
    this.panelProcessing.Visible = false;
    this.cmdCancelDownload.Visible = false;
    }
    
    private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
{
    if (this.tabControl1.SelectedIndex == 3)
    this.GetListOfDEfiles();
    if (this.tabControl1.SelectedIndex != 2)
    return;
    this.GetListOfDEfilesForDefaults();
    }
    
    private void GetListOfDEfiles()
{
    this.listViewDEfiles.Items.Clear();
    int index1 = 0;
    int index2 = 0;
    foreach (string file in Directory.GetFiles(Utilities.AppPath + "\\Resource Files\\", "DE*.bin"))
    {
    string fileName = Path.GetFileName(file);
    this.listViewDEfiles.Items.Add(fileName);
    if (fileName == JPL_DE.DE_Ephemeris_Version)
    {
    Create_JPL_DE_EphemerisFile.ProposedDEFile = fileName;
    this.listViewDEfiles.Items[index1].ForeColor = Color.DarkRed;
    this.listViewDEfiles.Items[index1].BackColor = Color.Yellow;
    index2 = index1;
    }
    ++index1;
    }
    this.listViewDEfiles.Focus();
    if (index1 > 0)
    this.listViewDEfiles.Items[index2].Selected = true;
    this.LBLCurrentVersion.Text = Utilities.EphemerisBasis();
    this.lblDEproposed.Text = JPL_DE.GetDE_VersionDetails(Create_JPL_DE_EphemerisFile.ProposedDEFile);
    }
    
    private void GetListOfDEfilesForDefaults()
{
    this.listViewDEfilesForDefaults.Items.Clear();
    int index = 0;
    foreach (string file in Directory.GetFiles(Utilities.AppPath + "\\Resource Files\\", "DE*.bin"))
    {
    string fileName = Path.GetFileName(file);
    this.listViewDEfilesForDefaults.Items.Add(fileName);
    if (fileName == "DE_Ephemeris.bin" | fileName == "DE_LongEphemeris.bin")
    {
    this.listViewDEfilesForDefaults.Items[index].ForeColor = Color.DarkRed;
    this.listViewDEfilesForDefaults.Items[index].BackColor = Color.Yellow;
    }
    ++index;
    }
    this.listViewDEfilesForDefaults.Focus();
    if (index > 0)
    this.listViewDEfilesForDefaults.Items[0].Selected = true;
    if (System.IO.File.Exists(Utilities.AppPath + "\\Resource Files\\DE_Ephemeris.bin"))
    this.lblCurrentDE_Ephem.Text = JPL_DE.GetDE_VersionDetails("DE_Ephemeris.bin");
    else
    this.lblCurrentDE_Ephem.Text = "No file set";
    if (System.IO.File.Exists(Utilities.AppPath + "\\Resource Files\\DE_LongEphemeris.bin"))
    this.lblCurrentDE_Long.Text = JPL_DE.GetDE_VersionDetails("DE_LongEphemeris.bin");
    else
    this.lblCurrentDE_Long.Text = "No file set";
    }
    
    private void listViewDEfiles_SelectedIndexChanged(object sender, EventArgs e)
{
    if (this.listViewDEfiles.SelectedIndices.Count > 0)
    Create_JPL_DE_EphemerisFile.ProposedDEFile = this.listViewDEfiles.Items[this.listViewDEfiles.SelectedIndices[0]].Text;
    this.lblDEproposed.Text = JPL_DE.GetDE_VersionDetails(Create_JPL_DE_EphemerisFile.ProposedDEFile);
    this.cmdUseSelectDEfile.Text = "Use " + Create_JPL_DE_EphemerisFile.ProposedDEFile;
    }
    
    private void cmdUseSelectDEfile_Click(object sender, EventArgs e)
{
    JPL_DE.DE_Ephemeris_Version = Create_JPL_DE_EphemerisFile.ProposedDEFile;
    JPL_DE.InitialiseDE_Ephemeris();
    JPL_DE.PurgeLunarCache();
    this.Close();
    this.Dispose();
    }
    
    private void listViewDEfilesForDefaults_SelectedIndexChanged(object sender, EventArgs e)
{
    if (this.listViewDEfilesForDefaults.SelectedIndices.Count > 0)
    Create_JPL_DE_EphemerisFile.ProposedDefaultFile = this.listViewDEfilesForDefaults.Items[this.listViewDEfilesForDefaults.SelectedIndices[0]].Text;
    string str = this.lblProposedDefault.Text = JPL_DE.GetDE_VersionDetails(Create_JPL_DE_EphemerisFile.ProposedDefaultFile);
    this.cmdSetDE_Ephemeris.Text = Create_JPL_DE_EphemerisFile.ProposedDefaultFile + " = " + str + "\r\n\r\nChange to DE_Ephemeris.bin file";
    this.cmdSetDE_Long.Text = Create_JPL_DE_EphemerisFile.ProposedDefaultFile + " = " + str + "\r\n\r\nChange to DE_LongEphemeris.bin file";
    this.cmdSetDE_Ephemeris.Enabled = this.cmdSetDE_Long.Enabled = !(Create_JPL_DE_EphemerisFile.ProposedDefaultFile == "DE_Ephemeris.bin" | Create_JPL_DE_EphemerisFile.ProposedDefaultFile == "DE_LongEphemeris.bin");
    }
    
    private void cmdSetDE_Ephemeris_Click(object sender, EventArgs e)
{
    if (MessageBox.Show("This will rename the current DE_Ephemeris file to a DE file name\r\nand rename " + Create_JPL_DE_EphemerisFile.ProposedDefaultFile + " to DE_Ephemeris.bin\r\n\r\nDo you want to proceed?", "Confirm change", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.No)
    return;
    JPL_DE.Set_DE_EphemerisFile(Create_JPL_DE_EphemerisFile.ProposedDefaultFile);
    JPL_DE.PurgeLunarCache();
    this.GetListOfDEfilesForDefaults();
    }
    
    private void cmdSetDE_Long_Click(object sender, EventArgs e)
{
    if (MessageBox.Show("This will rename the current DE_LongEphemeris file to a DE file name\r\nand rename " + Create_JPL_DE_EphemerisFile.ProposedDefaultFile + " to DE_LongEphemeris.bin\r\n\r\nDo you want to proceed?", "Confirm change", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.No)
    return;
    JPL_DE.Set_DE_LongEphemerisFile(Create_JPL_DE_EphemerisFile.ProposedDefaultFile);
    JPL_DE.PurgeLunarCache();
    this.GetListOfDEfilesForDefaults();
    }
    
    private void Create_JPL_DE_EphemerisFile_FormClosed(object sender, FormClosedEventArgs e)
{
    JPL_DE.CreateDEfile = (Create_JPL_DE_EphemerisFile) null;
    }
    
    private void cmdClose_Click(object sender, EventArgs e)
{
    this.Close();
    this.Dispose();
    }
    
    private void cmdCancelDownload_Click(object sender, EventArgs e)
{
    ftp.CancelFlag = true;
    }
    
    protected override void Dispose(bool disposing)
    {
    if (disposing && this.components != null)
    this.components.Dispose();
    base.Dispose(disposing);
    }
    
    private void InitializeComponent()
{
    this.components = (IContainer) new Container();
    ComponentResourceManager componentResourceManager = new ComponentResourceManager(typeof (Create_JPL_DE_EphemerisFile));
    this.cmdSelectDEfolder = new Button();
    this.lblSource = new Label();
    this.lblHeader = new Label();
    this.cmdCreateDEfile = new Button();
    this.pBarBlock = new ProgressBar();
    this.panelPBar = new Panel();
    this.lblFileProcessing = new Label();
    this.label4 = new Label();
    this.label2 = new Label();
    this.lblContinuity = new Label();
    this.menuStrip1 = new MenuStrip();
    this.helpToolStripMenuItem = new ToolStripMenuItem();
    this.exitToolStripMenuItem = new ToolStripMenuItem();
    this.tabControl1 = new TabControl();
    this.tabDownload = new TabPage();
    this.cmdCancelDownload = new Button();
    this.label8 = new Label();
    this.label7 = new Label();
    this.label3 = new Label();
    this.label1 = new Label();
    this.listViewDownload = new ListView();
    this.cmdDownload = new Button();
    this.lblFiles = new Label();
    this.lstVersions = new ListBox();
    this.cmdListVersions = new Button();
    this.panelProcessing = new Panel();
    this.label6 = new Label();
    this.lblFile = new Label();
    this.tabConvert = new TabPage();
    this.listViewFiles = new ListView();
    this.tabDefaults = new TabPage();
    this.lblProposedDefault = new Label();
    this.grpSetDE_Long = new GroupBox();
    this.cmdSetDE_Long = new Button();
    this.label14 = new Label();
    this.lblCurrentDE_Long = new Label();
    this.grpSetDEEphemeris = new GroupBox();
    this.cmdSetDE_Ephemeris = new Button();
    this.lblCurrentDE_Ephem = new Label();
    this.label13 = new Label();
    this.label12 = new Label();
    this.listViewDEfilesForDefaults = new ListView();
    this.tabSetTemporary = new TabPage();
    this.label15 = new Label();
    this.cmdClose = new Button();
    this.label11 = new Label();
    this.cmdUseSelectDEfile = new Button();
    this.lblLabel11 = new Label();
    this.lblDEproposed = new Label();
    this.label10 = new Label();
    this.LBLCurrentVersion = new Label();
    this.listViewDEfiles = new ListView();
    this.label9 = new Label();
    this.label5 = new Label();
    this.toolTip1 = new ToolTip(this.components);
    this.panelPBar.SuspendLayout();
    this.menuStrip1.SuspendLayout();
    this.tabControl1.SuspendLayout();
    this.tabDownload.SuspendLayout();
    this.panelProcessing.SuspendLayout();
    this.tabConvert.SuspendLayout();
    this.tabDefaults.SuspendLayout();
    this.grpSetDE_Long.SuspendLayout();
    this.grpSetDEEphemeris.SuspendLayout();
    this.tabSetTemporary.SuspendLayout();
    this.SuspendLayout();
    this.cmdSelectDEfolder.Location = new Point(112, 17);
    this.cmdSelectDEfolder.Name = "cmdSelectDEfolder";
    this.cmdSelectDEfolder.Size = new Size(265, 27);
    this.cmdSelectDEfolder.TabIndex = 1;
    this.cmdSelectDEfolder.Text = "Select the folder containing JPL-DE source files";
    this.cmdSelectDEfolder.UseVisualStyleBackColor = true;
    this.cmdSelectDEfolder.Click += new EventHandler(this.cmdSelectDEfolder_Click);
    this.lblSource.AutoSize = true;
    this.lblSource.Location = new Point(6, 49);
    this.lblSource.Name = "lblSource";
    this.lblSource.Size = new Size(98, 13);
    this.lblSource.TabIndex = 2;
    this.lblSource.Text = "Source file folder = ";
    this.lblHeader.AutoSize = true;
    this.lblHeader.Location = new Point(6, 67);
    this.lblHeader.Name = "lblHeader";
    this.lblHeader.Size = new Size(70, 13);
    this.lblHeader.TabIndex = 3;
    this.lblHeader.Text = "Header file = ";
    this.cmdCreateDEfile.Enabled = false;
    this.cmdCreateDEfile.Location = new Point(73, 355);
    this.cmdCreateDEfile.Name = "cmdCreateDEfile";
    this.cmdCreateDEfile.Size = new Size(138, 41);
    this.cmdCreateDEfile.TabIndex = 5;
    this.cmdCreateDEfile.Text = "Create DExxx file";
    this.cmdCreateDEfile.UseVisualStyleBackColor = true;
    this.cmdCreateDEfile.Click += new EventHandler(this.cmdCreateDEfile_Click);
    this.pBarBlock.Location = new Point(40, 36);
    this.pBarBlock.MarqueeAnimationSpeed = 1;
    this.pBarBlock.Maximum = 10;
    this.pBarBlock.Name = "pBarBlock";
    this.pBarBlock.Size = new Size(130, 9);
    this.pBarBlock.Step = 1;
    this.pBarBlock.TabIndex = 7;
    this.panelPBar.Controls.Add((Control) this.lblFileProcessing);
    this.panelPBar.Controls.Add((Control) this.label4);
    this.panelPBar.Controls.Add((Control) this.label2);
    this.panelPBar.Controls.Add((Control) this.pBarBlock);
    this.panelPBar.Location = new Point(236, 350);
    this.panelPBar.Name = "panelPBar";
    this.panelPBar.Size = new Size(179, 49);
    this.panelPBar.TabIndex = 8;
    this.panelPBar.Visible = false;
    this.lblFileProcessing.AutoSize = true;
    this.lblFileProcessing.Location = new Point(39, 17);
    this.lblFileProcessing.Name = "lblFileProcessing";
    this.lblFileProcessing.Size = new Size(27, 13);
    this.lblFileProcessing.TabIndex = 11;
    this.lblFileProcessing.Text = "xxxx";
    this.label4.AutoSize = true;
    this.label4.Location = new Point(55, 3);
    this.label4.Name = "label4";
    this.label4.Size = new Size(68, 13);
    this.label4.TabIndex = 10;
    this.label4.Text = "Processing...";
    this.label2.AutoSize = true;
    this.label2.Location = new Point(3, 17);
    this.label2.Name = "label2";
    this.label2.Size = new Size(23, 13);
    this.label2.TabIndex = 8;
    this.label2.Text = "File";
    this.lblContinuity.AutoSize = true;
    this.lblContinuity.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.lblContinuity.ForeColor = Color.DarkRed;
    this.lblContinuity.Location = new Point(3, 331);
    this.lblContinuity.Name = "lblContinuity";
    this.lblContinuity.Size = new Size(63, 13);
    this.lblContinuity.TabIndex = 10;
    this.lblContinuity.Text = "Continuity";
    this.menuStrip1.Items.AddRange(new ToolStripItem[2]
    {
    (ToolStripItem) this.helpToolStripMenuItem,
    (ToolStripItem) this.exitToolStripMenuItem
    });
    this.menuStrip1.Location = new Point(0, 0);
    this.menuStrip1.Name = "menuStrip1";
    this.menuStrip1.Size = new Size(515, 24);
    this.menuStrip1.TabIndex = 11;
    this.menuStrip1.Text = "menuStrip1";
    this.helpToolStripMenuItem.Image = (Image) Resources.help;
    this.helpToolStripMenuItem.Name = "helpToolStripMenuItem";
    this.helpToolStripMenuItem.Size = new Size(75, 20);
    this.helpToolStripMenuItem.Text = "Help     ";
    this.helpToolStripMenuItem.Click += new EventHandler(this.helpToolStripMenuItem_Click);
    this.exitToolStripMenuItem.Image = (Image) Resources.error;
    this.exitToolStripMenuItem.Name = "exitToolStripMenuItem";
    this.exitToolStripMenuItem.Size = new Size(53, 20);
    this.exitToolStripMenuItem.Text = "Exit";
    this.exitToolStripMenuItem.Click += new EventHandler(this.exitToolStripMenuItem_Click);
    this.tabControl1.Controls.Add((Control) this.tabDownload);
    this.tabControl1.Controls.Add((Control) this.tabConvert);
    this.tabControl1.Controls.Add((Control) this.tabDefaults);
    this.tabControl1.Controls.Add((Control) this.tabSetTemporary);
    this.tabControl1.Location = new Point(12, 48);
    this.tabControl1.Name = "tabControl1";
    this.tabControl1.SelectedIndex = 0;
    this.tabControl1.Size = new Size(496, 428);
    this.tabControl1.TabIndex = 12;
    this.tabControl1.SelectedIndexChanged += new EventHandler(this.tabControl1_SelectedIndexChanged);
    this.tabDownload.Controls.Add((Control) this.cmdCancelDownload);
    this.tabDownload.Controls.Add((Control) this.label8);
    this.tabDownload.Controls.Add((Control) this.label7);
    this.tabDownload.Controls.Add((Control) this.label3);
    this.tabDownload.Controls.Add((Control) this.label1);
    this.tabDownload.Controls.Add((Control) this.listViewDownload);
    this.tabDownload.Controls.Add((Control) this.cmdDownload);
    this.tabDownload.Controls.Add((Control) this.lblFiles);
    this.tabDownload.Controls.Add((Control) this.lstVersions);
    this.tabDownload.Controls.Add((Control) this.cmdListVersions);
    this.tabDownload.Controls.Add((Control) this.panelProcessing);
    this.tabDownload.Location = new Point(4, 22);
    this.tabDownload.Name = "tabDownload";
    this.tabDownload.Padding = new Padding(3);
    this.tabDownload.Size = new Size(488, 402);
    this.tabDownload.TabIndex = 0;
    this.tabDownload.Text = "Download DE source files";
    this.tabDownload.UseVisualStyleBackColor = true;
    this.cmdCancelDownload.BackColor = Color.Yellow;
    this.cmdCancelDownload.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.cmdCancelDownload.ForeColor = Color.Red;
    this.cmdCancelDownload.Location = new Point(329, 64);
    this.cmdCancelDownload.Name = "cmdCancelDownload";
    this.cmdCancelDownload.Size = new Size(143, 31);
    this.cmdCancelDownload.TabIndex = 20;
    this.cmdCancelDownload.Text = "Cancel download";
    this.cmdCancelDownload.UseVisualStyleBackColor = false;
    this.cmdCancelDownload.Visible = false;
    this.cmdCancelDownload.Click += new EventHandler(this.cmdCancelDownload_Click);
    this.label8.AutoSize = true;
    this.label8.ForeColor = Color.Red;
    this.label8.Location = new Point(222, 50);
    this.label8.Name = "label8";
    this.label8.Size = new Size(103, 13);
    this.label8.TabIndex = 19;
    this.label8.Text = "Download has failed";
    this.label7.AutoSize = true;
    this.label7.ForeColor = Color.DarkGreen;
    this.label7.Location = new Point(76, 50);
    this.label7.Name = "label7";
    this.label7.Size = new Size(131, 13);
    this.label7.TabIndex = 18;
    this.label7.Text = "File has been downloaded";
    this.label3.AutoSize = true;
    this.label3.ForeColor = Color.DarkOrange;
    this.label3.Location = new Point(76, 37);
    this.label3.Name = "label3";
    this.label3.Size = new Size(254, 13);
    this.label3.TabIndex = 17;
    this.label3.Text = "File has been downloaded, but has the wrong length";
    this.label1.AutoSize = true;
    this.label1.Location = new Point(76, 24);
    this.label1.Name = "label1";
    this.label1.Size = new Size(149, 13);
    this.label1.TabIndex = 16;
    this.label1.Text = "File has not been downloaded";
    this.listViewDownload.CheckBoxes = true;
    this.listViewDownload.Font = new Font("Courier New", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.listViewDownload.Location = new Point(77, 69);
    this.listViewDownload.Name = "listViewDownload";
    this.listViewDownload.Size = new Size(395, 326);
    this.listViewDownload.TabIndex = 15;
    this.listViewDownload.UseCompatibleStateImageBehavior = false;
    this.listViewDownload.View = View.List;
    this.cmdDownload.Location = new Point(329, 6);
    this.cmdDownload.Name = "cmdDownload";
    this.cmdDownload.Size = new Size(143, 31);
    this.cmdDownload.TabIndex = 5;
    this.cmdDownload.Text = "Download selected files";
    this.cmdDownload.UseVisualStyleBackColor = true;
    this.cmdDownload.Click += new EventHandler(this.cmdDownload_Click);
    this.lblFiles.AutoSize = true;
    this.lblFiles.Font = new Font("Microsoft Sans Serif", 10f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.lblFiles.Location = new Point(140, 7);
    this.lblFiles.Name = "lblFiles";
    this.lblFiles.Size = new Size(113, 17);
    this.lblFiles.TabIndex = 4;
    this.lblFiles.Text = "Files for DE....";
    this.lstVersions.Font = new Font("Courier New", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.lstVersions.FormattingEnabled = true;
    this.lstVersions.ItemHeight = 14;
    this.lstVersions.Location = new Point(7, 69);
    this.lstVersions.Name = "lstVersions";
    this.lstVersions.Size = new Size(64, 326);
    this.lstVersions.TabIndex = 1;
    this.toolTip1.SetToolTip((Control) this.lstVersions, "double-click to list files");
    this.lstVersions.DoubleClick += new EventHandler(this.lstVersions_DoubleClick);
    this.cmdListVersions.Location = new Point(7, 6);
    this.cmdListVersions.Name = "cmdListVersions";
    this.cmdListVersions.Size = new Size(64, 52);
    this.cmdListVersions.TabIndex = 0;
    this.cmdListVersions.Text = "Get available versions";
    this.cmdListVersions.UseVisualStyleBackColor = true;
    this.cmdListVersions.Click += new EventHandler(this.cmdListVersions_Click);
    this.panelProcessing.Controls.Add((Control) this.label6);
    this.panelProcessing.Controls.Add((Control) this.lblFile);
    this.panelProcessing.Location = new Point(338, 35);
    this.panelProcessing.Name = "panelProcessing";
    this.panelProcessing.Size = new Size(129, 28);
    this.panelProcessing.TabIndex = 14;
    this.panelProcessing.Visible = false;
    this.label6.AutoSize = true;
    this.label6.Location = new Point(6, 1);
    this.label6.Name = "label6";
    this.label6.Size = new Size(78, 13);
    this.label6.TabIndex = 13;
    this.label6.Text = "Downloading...";
    this.lblFile.AutoSize = true;
    this.lblFile.Location = new Point(6, 13);
    this.lblFile.Name = "lblFile";
    this.lblFile.Size = new Size(23, 13);
    this.lblFile.TabIndex = 12;
    this.lblFile.Text = "File";
    this.tabConvert.Controls.Add((Control) this.lblSource);
    this.tabConvert.Controls.Add((Control) this.listViewFiles);
    this.tabConvert.Controls.Add((Control) this.cmdSelectDEfolder);
    this.tabConvert.Controls.Add((Control) this.lblHeader);
    this.tabConvert.Controls.Add((Control) this.cmdCreateDEfile);
    this.tabConvert.Controls.Add((Control) this.lblContinuity);
    this.tabConvert.Controls.Add((Control) this.panelPBar);
    this.tabConvert.Location = new Point(4, 22);
    this.tabConvert.Name = "tabConvert";
    this.tabConvert.Padding = new Padding(3);
    this.tabConvert.Size = new Size(488, 402);
    this.tabConvert.TabIndex = 1;
    this.tabConvert.Text = "Convert DE source files";
    this.tabConvert.UseVisualStyleBackColor = true;
    this.listViewFiles.CheckBoxes = true;
    this.listViewFiles.Font = new Font("Courier New", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.listViewFiles.Location = new Point(8, 85);
    this.listViewFiles.MultiSelect = false;
    this.listViewFiles.Name = "listViewFiles";
    this.listViewFiles.Size = new Size(469, 236);
    this.listViewFiles.TabIndex = 11;
    this.listViewFiles.UseCompatibleStateImageBehavior = false;
    this.listViewFiles.View = View.List;
    this.listViewFiles.Click += new EventHandler(this.listViewFiles_Click);
    this.tabDefaults.Controls.Add((Control) this.lblProposedDefault);
    this.tabDefaults.Controls.Add((Control) this.grpSetDE_Long);
    this.tabDefaults.Controls.Add((Control) this.grpSetDEEphemeris);
    this.tabDefaults.Controls.Add((Control) this.label12);
    this.tabDefaults.Controls.Add((Control) this.listViewDEfilesForDefaults);
    this.tabDefaults.Location = new Point(4, 22);
    this.tabDefaults.Name = "tabDefaults";
    this.tabDefaults.Size = new Size(488, 402);
    this.tabDefaults.TabIndex = 2;
    this.tabDefaults.Text = "Set default versions";
    this.tabDefaults.UseVisualStyleBackColor = true;
    this.lblProposedDefault.AutoSize = true;
    this.lblProposedDefault.Location = new Point(59, 39);
    this.lblProposedDefault.Name = "lblProposedDefault";
    this.lblProposedDefault.Size = new Size(90, 13);
    this.lblProposedDefault.TabIndex = 12;
    this.lblProposedDefault.Text = " Proposed default";
    this.grpSetDE_Long.Controls.Add((Control) this.cmdSetDE_Long);
    this.grpSetDE_Long.Controls.Add((Control) this.label14);
    this.grpSetDE_Long.Controls.Add((Control) this.lblCurrentDE_Long);
    this.grpSetDE_Long.Location = new Point(181, 253);
    this.grpSetDE_Long.Name = "grpSetDE_Long";
    this.grpSetDE_Long.Size = new Size(268, 142);
    this.grpSetDE_Long.TabIndex = 11;
    this.grpSetDE_Long.TabStop = false;
    this.grpSetDE_Long.Text = "Set DE Long Ephemeris";
    this.cmdSetDE_Long.Location = new Point(12, 69);
    this.cmdSetDE_Long.Name = "cmdSetDE_Long";
    this.cmdSetDE_Long.Size = new Size(244, 65);
    this.cmdSetDE_Long.TabIndex = 4;
    this.cmdSetDE_Long.Text = "Set";
    this.cmdSetDE_Long.UseVisualStyleBackColor = true;
    this.cmdSetDE_Long.Click += new EventHandler(this.cmdSetDE_Long_Click);
    this.label14.AutoSize = true;
    this.label14.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.label14.Location = new Point(10, 21);
    this.label14.Name = "label14";
    this.label14.Size = new Size(183, 13);
    this.label14.TabIndex = 1;
    this.label14.Text = "Current DE_LongEphemeris.bin";
    this.lblCurrentDE_Long.AutoSize = true;
    this.lblCurrentDE_Long.Location = new Point(10, 34);
    this.lblCurrentDE_Long.Name = "lblCurrentDE_Long";
    this.lblCurrentDE_Long.Size = new Size(52, 13);
    this.lblCurrentDE_Long.TabIndex = 1;
    this.lblCurrentDE_Long.Text = "DE_Long";
    this.grpSetDEEphemeris.Controls.Add((Control) this.cmdSetDE_Ephemeris);
    this.grpSetDEEphemeris.Controls.Add((Control) this.lblCurrentDE_Ephem);
    this.grpSetDEEphemeris.Controls.Add((Control) this.label13);
    this.grpSetDEEphemeris.Location = new Point(181, 101);
    this.grpSetDEEphemeris.Name = "grpSetDEEphemeris";
    this.grpSetDEEphemeris.Size = new Size(268, 142);
    this.grpSetDEEphemeris.TabIndex = 10;
    this.grpSetDEEphemeris.TabStop = false;
    this.grpSetDEEphemeris.Text = "Set DE Ephemeris";
    this.cmdSetDE_Ephemeris.Location = new Point(12, 69);
    this.cmdSetDE_Ephemeris.Name = "cmdSetDE_Ephemeris";
    this.cmdSetDE_Ephemeris.Size = new Size(244, 65);
    this.cmdSetDE_Ephemeris.TabIndex = 3;
    this.cmdSetDE_Ephemeris.Text = "Set";
    this.cmdSetDE_Ephemeris.UseVisualStyleBackColor = true;
    this.cmdSetDE_Ephemeris.Click += new EventHandler(this.cmdSetDE_Ephemeris_Click);
    this.lblCurrentDE_Ephem.AutoSize = true;
    this.lblCurrentDE_Ephem.Location = new Point(10, 34);
    this.lblCurrentDE_Ephem.Name = "lblCurrentDE_Ephem";
    this.lblCurrentDE_Ephem.Size = new Size(61, 13);
    this.lblCurrentDE_Ephem.TabIndex = 2;
    this.lblCurrentDE_Ephem.Text = "DE_Ephem";
    this.label13.AutoSize = true;
    this.label13.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.label13.Location = new Point(10, 21);
    this.label13.Name = "label13";
    this.label13.Size = new Size(155, 13);
    this.label13.TabIndex = 0;
    this.label13.Text = "Current DE_Ephemeris.bin";
    this.label12.AutoSize = true;
    this.label12.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.label12.Location = new Point(5, 83);
    this.label12.Name = "label12";
    this.label12.Size = new Size(155, 13);
    this.label12.TabIndex = 9;
    this.label12.Text = "Available DE ephemerides";
    this.listViewDEfilesForDefaults.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.listViewDEfilesForDefaults.Location = new Point(3, 99);
    this.listViewDEfilesForDefaults.MultiSelect = false;
    this.listViewDEfilesForDefaults.Name = "listViewDEfilesForDefaults";
    this.listViewDEfilesForDefaults.Size = new Size(157, 300);
    this.listViewDEfilesForDefaults.TabIndex = 8;
    this.listViewDEfilesForDefaults.UseCompatibleStateImageBehavior = false;
    this.listViewDEfilesForDefaults.View = View.List;
    this.listViewDEfilesForDefaults.SelectedIndexChanged += new EventHandler(this.listViewDEfilesForDefaults_SelectedIndexChanged);
    this.tabSetTemporary.Controls.Add((Control) this.label15);
    this.tabSetTemporary.Controls.Add((Control) this.cmdClose);
    this.tabSetTemporary.Controls.Add((Control) this.label11);
    this.tabSetTemporary.Controls.Add((Control) this.cmdUseSelectDEfile);
    this.tabSetTemporary.Controls.Add((Control) this.lblLabel11);
    this.tabSetTemporary.Controls.Add((Control) this.lblDEproposed);
    this.tabSetTemporary.Controls.Add((Control) this.label10);
    this.tabSetTemporary.Controls.Add((Control) this.LBLCurrentVersion);
    this.tabSetTemporary.Controls.Add((Control) this.listViewDEfiles);
    this.tabSetTemporary.Controls.Add((Control) this.label9);
    this.tabSetTemporary.Location = new Point(4, 22);
    this.tabSetTemporary.Name = "tabSetTemporary";
    this.tabSetTemporary.Size = new Size(488, 402);
    this.tabSetTemporary.TabIndex = 3;
    this.tabSetTemporary.Text = "Set temporary version";
    this.tabSetTemporary.UseVisualStyleBackColor = true;
    this.label15.AutoSize = true;
    this.label15.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.label15.Location = new Point(15, 10);
    this.label15.Name = "label15";
    this.label15.Size = new Size(454, 13);
    this.label15.TabIndex = 9;
    this.label15.Text = "Temporarily set the DE Ephemeris being used in the current session of Occult. ";
    this.cmdClose.Location = new Point(238, 319);
    this.cmdClose.Name = "cmdClose";
    this.cmdClose.Size = new Size(137, 36);
    this.cmdClose.TabIndex = 8;
    this.cmdClose.Text = "Close - with no changes";
    this.cmdClose.UseVisualStyleBackColor = true;
    this.cmdClose.Click += new EventHandler(this.cmdClose_Click);
    this.label11.AutoSize = true;
    this.label11.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.label11.Location = new Point(21, 115);
    this.label11.Name = "label11";
    this.label11.Size = new Size(155, 13);
    this.label11.TabIndex = 7;
    this.label11.Text = "Available DE ephemerides";
    this.cmdUseSelectDEfile.Location = new Point(238, 260);
    this.cmdUseSelectDEfile.Name = "cmdUseSelectDEfile";
    this.cmdUseSelectDEfile.Size = new Size(137, 42);
    this.cmdUseSelectDEfile.TabIndex = 6;
    this.cmdUseSelectDEfile.Text = "Set selected DE file\r\n&& close";
    this.cmdUseSelectDEfile.UseVisualStyleBackColor = true;
    this.cmdUseSelectDEfile.Click += new EventHandler(this.cmdUseSelectDEfile_Click);
    this.lblLabel11.AutoSize = true;
    this.lblLabel11.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.lblLabel11.Location = new Point(238, 186);
    this.lblLabel11.Name = "lblLabel11";
    this.lblLabel11.Size = new Size(170, 13);
    this.lblLabel11.TabIndex = 5;
    this.lblLabel11.Text = "Coverage of selected DE file";
    this.lblDEproposed.AutoSize = true;
    this.lblDEproposed.Location = new Point(238, 208);
    this.lblDEproposed.Name = "lblDEproposed";
    this.lblDEproposed.Size = new Size(52, 13);
    this.lblDEproposed.TabIndex = 4;
    this.lblDEproposed.Text = "Proposed";
    this.label10.AutoSize = true;
    this.label10.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.label10.Location = new Point(238, 122);
    this.label10.Name = "label10";
    this.label10.Size = new Size(211, 13);
    this.label10.TabIndex = 3;
    this.label10.Text = "Coverage of current default DE files";
    this.LBLCurrentVersion.AutoSize = true;
    this.LBLCurrentVersion.Location = new Point(238, 144);
    this.LBLCurrentVersion.Name = "LBLCurrentVersion";
    this.LBLCurrentVersion.Size = new Size(41, 13);
    this.LBLCurrentVersion.TabIndex = 2;
    this.LBLCurrentVersion.Text = "Current";
    this.listViewDEfiles.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.listViewDEfiles.Location = new Point(19, 131);
    this.listViewDEfiles.MultiSelect = false;
    this.listViewDEfiles.Name = "listViewDEfiles";
    this.listViewDEfiles.Size = new Size(157, 254);
    this.listViewDEfiles.TabIndex = 1;
    this.listViewDEfiles.UseCompatibleStateImageBehavior = false;
    this.listViewDEfiles.View = View.List;
    this.listViewDEfiles.SelectedIndexChanged += new EventHandler(this.listViewDEfiles_SelectedIndexChanged);
    this.label9.AutoSize = true;
    this.label9.Location = new Point(14, 32);
    this.label9.Name = "label9";
    this.label9.Size = new Size(367, 52);
    this.label9.TabIndex = 0;
    this.label9.Text = componentResourceManager.GetString("label9.Text");
    this.label5.AutoSize = true;
    this.label5.BackColor = Color.Yellow;
    this.label5.Font = new Font("Microsoft Sans Serif", 8.25f, FontStyle.Bold, GraphicsUnit.Point, (byte) 0);
    this.label5.ForeColor = Color.DarkRed;
    this.label5.Location = new Point(103, 29);
    this.label5.Name = "label5";
    this.label5.Size = new Size(308, 13);
    this.label5.TabIndex = 2;
    this.label5.Text = "This routine cannot convert DE 102, 200, 202, && 406";
    this.toolTip1.AutomaticDelay = 100;
    this.toolTip1.AutoPopDelay = 5000;
    this.toolTip1.InitialDelay = 10;
    this.toolTip1.ReshowDelay = 20;
    this.toolTip1.ShowAlways = true;
    this.AutoScaleDimensions = new SizeF(6f, 13f);
    this.AutoScaleMode = AutoScaleMode.Font;
    this.ClientSize = new Size(515, 489);
    this.Controls.Add((Control) this.label5);
    this.Controls.Add((Control) this.tabControl1);
    this.Controls.Add((Control) this.menuStrip1);
    this.FormBorderStyle = FormBorderStyle.Fixed3D;
    this.MainMenuStrip = this.menuStrip1;
    this.Name = nameof (Create_JPL_DE_EphemerisFile);
    this.Text = "Create JPL_DE ephemeris file";
    this.FormClosed += new FormClosedEventHandler(this.Create_JPL_DE_EphemerisFile_FormClosed);
    this.Load += new EventHandler(this.Create_JPL_DE_EphemerisFile_Load);
    this.panelPBar.ResumeLayout(false);
    this.panelPBar.PerformLayout();
    this.menuStrip1.ResumeLayout(false);
    this.menuStrip1.PerformLayout();
    this.tabControl1.ResumeLayout(false);
    this.tabDownload.ResumeLayout(false);
    this.tabDownload.PerformLayout();
    this.panelProcessing.ResumeLayout(false);
    this.panelProcessing.PerformLayout();
    this.tabConvert.ResumeLayout(false);
    this.tabConvert.PerformLayout();
    this.tabDefaults.ResumeLayout(false);
    this.tabDefaults.PerformLayout();
    this.grpSetDE_Long.ResumeLayout(false);
    this.grpSetDE_Long.PerformLayout();
    this.grpSetDEEphemeris.ResumeLayout(false);
    this.grpSetDEEphemeris.PerformLayout();
    this.tabSetTemporary.ResumeLayout(false);
    this.tabSetTemporary.PerformLayout();
    this.ResumeLayout(false);
    this.PerformLayout();
    }
}
}


private void cmdSelectDEfolder_Click(object sender, EventArgs e)
{
    string str1 = "";
    bool flag = false;
    FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
    folderBrowserDialog.ShowNewFolderButton = false;
    folderBrowserDialog.SelectedPath = Create_JPL_DE_EphemerisFile.SourceFileFolder;
    folderBrowserDialog.Description = "Select folder containing JPL-DE source files";
    if (folderBrowserDialog.ShowDialog() != DialogResult.OK)
    return;
    Create_JPL_DE_EphemerisFile.SourceFileFolder = folderBrowserDialog.SelectedPath;
    Create_JPL_DE_EphemerisFile.SourceHeader = "";
    this.lblSource.Text = "Source file folder = " + Create_JPL_DE_EphemerisFile.SourceFileFolder;
    Create_JPL_DE_EphemerisFile.Sources.Clear();
    this.listViewFiles.Items.Clear();
    this.listViewFiles.Items.Add("File name       Start Date       End Date");
    this.listViewFiles.Items[0].Checked = false;
    this.listViewFiles.Items[0].ForeColor = Color.DarkBlue;
    foreach (string file in Directory.GetFiles(Create_JPL_DE_EphemerisFile.SourceFileFolder))
    {
        int result;
        if (!int.TryParse(Path.GetExtension(file).Replace(".", "").PadRight(3).Substring(0, 3), out result))
        result = 0;
        if (result != 0)
        {
            string withoutExtension = Path.GetFileNameWithoutExtension(file);
            if (withoutExtension.ToLower().Contains("header") & !flag)
            {
                Create_JPL_DE_EphemerisFile.SourceHeader = file;
                this.lblHeader.Text = "Header file = " + Path.GetFileName(file);
                flag = true;
            }
            else if (withoutExtension.ToLower().PadRight(3).Substring(0, 3).Contains("asc"))
            {
                if (str1.Length == 0)
                {
                    str1 = Path.GetExtension(file);
                    Create_JPL_DE_EphemerisFile.SourcePath = Path.GetDirectoryName(file);
                    Create_JPL_DE_EphemerisFile.Version = str1.Replace(".", "");
                }
                this.SourceFile = new DESourceFiles();
                this.SourceFile.File = file;
                this.SourceFile.FileName = Path.GetFileName(file);
                using (StreamReader streamReader = new StreamReader(file))
                {
                    streamReader.ReadLine();
                    this.SourceFile.StartJD = double.Parse(streamReader.ReadLine().Replace("D", "E").Substring(0, 26));
                }
                Create_JPL_DE_EphemerisFile.Sources.Add(this.SourceFile);
            }
        }
    }
    Create_JPL_DE_EphemerisFile.Sources.Sort();
    if (Create_JPL_DE_EphemerisFile.SourceHeader == "")
    {
        int num1 = (int) MessageBox.Show("No header file found. Conversion cannot proceed", "No Header file", MessageBoxButtons.OK);
    }
    else
    {
        using (StreamReader streamReader = new StreamReader(Create_JPL_DE_EphemerisFile.SourceHeader))
        {
            string str2 = streamReader.ReadLine();
            int startIndex = str2.IndexOf("NCOEFF=") + 7;
            Create_JPL_DE_EphemerisFile.SourceBlockLength = 26873;
            if (!int.TryParse(str2.Substring(startIndex), out Create_JPL_DE_EphemerisFile.NCoeff))
            Create_JPL_DE_EphemerisFile.NCoeff = 0;
            switch (Create_JPL_DE_EphemerisFile.NCoeff)
            {
            case 938:
                Create_JPL_DE_EphemerisFile.NoNutations = true;
                Create_JPL_DE_EphemerisFile.SourceBlockLength = 24714;
                break;
            case 1018:
                Create_JPL_DE_EphemerisFile.NoNutations = false;
                Create_JPL_DE_EphemerisFile.SourceBlockLength = 26873;
                if (new FileInfo(Create_JPL_DE_EphemerisFile.Sources[0].File).Length % (long) Create_JPL_DE_EphemerisFile.SourceBlockLength != 0L)
                {
                    Create_JPL_DE_EphemerisFile.SourceBlockLength = 26821;
                    break;
                }
                break;
            default:
                int num2 = (int) MessageBox.Show("Source files are incompatible with this conversion routine. Conversion will not proceed", "Incompatible files", MessageBoxButtons.OK);
                return;
            }
        }
        for (int index = 0; index < Create_JPL_DE_EphemerisFile.Sources.Count; ++index)
        {
            Create_JPL_DE_EphemerisFile.Sources[index].EndJD = Create_JPL_DE_EphemerisFile.Sources[index].StartJD + (double) (new FileInfo(Create_JPL_DE_EphemerisFile.Sources[index].File).Length / (long) Create_JPL_DE_EphemerisFile.SourceBlockLength * 32L);
            this.listViewFiles.Items.Add(Create_JPL_DE_EphemerisFile.Sources[index].ToString());
            this.listViewFiles.Items[index + 1].Checked = true;
            this.listViewFiles.Items[index + 1].ForeColor = Color.Green;
            if (index > 0)
            Create_JPL_DE_EphemerisFile.FilesAreContinuous &= Create_JPL_DE_EphemerisFile.Sources[index].StartJD <= Create_JPL_DE_EphemerisFile.Sources[index - 1].EndJD;
        }
        this.GetCheckRange();
    }
}

*****/
