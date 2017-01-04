#include <sourcemod>
#include <sdktools>

#pragma newdecls required

// Plugin Informaiton  
#define VERSION "1.01"

//Paths
#define PATH_BASE "configs/easydownloader/"

//Mode
#define MODE_DECALS 0
#define MODE_GENERICS 1
#define MODE_MODELS 2
#define MODE_SENTENCEFILES 3
#define MODE_SOUNDS 4
#define MODE_DOWNLOADONLY 5

char modeNiceNames[6][PLATFORM_MAX_PATH];

public Plugin myinfo =
{
  name = "Easy Downloader",
  author = "Invex | Byte",
  description = "Download/Precache Files.",
  version = VERSION,
  url = "http://www.invexgaming.com.au"
};

public void OnPluginStart()
{
  modeNiceNames[MODE_DECALS] = "decals.txt";
  modeNiceNames[MODE_GENERICS] = "generics.txt";
  modeNiceNames[MODE_MODELS] = "models.txt";
  modeNiceNames[MODE_SENTENCEFILES] = "sentencefiles.txt";
  modeNiceNames[MODE_SOUNDS] = "sounds.txt";
  modeNiceNames[MODE_DOWNLOADONLY] = "downloadonly.txt";
}

public void OnMapStart()
{
  //Read and process config files for all modes
  readProcessConfig(MODE_DECALS);
  readProcessConfig(MODE_GENERICS);
  readProcessConfig(MODE_MODELS);
  readProcessConfig(MODE_SENTENCEFILES);
  readProcessConfig(MODE_SOUNDS);
  readProcessConfig(MODE_DOWNLOADONLY);
}

/**
* Read and process config files based on input mode 
*/
public void readProcessConfig(int mode)
{
  char configFilePath[PLATFORM_MAX_PATH];
  Format(configFilePath, sizeof(configFilePath), "%s%s", PATH_BASE, modeNiceNames[mode]);
  BuildPath(Path_SM, configFilePath, PLATFORM_MAX_PATH, configFilePath);
  
  if (FileExists(configFilePath)) {
    //Open config file
    File file = OpenFile(configFilePath, "r");
    
    if (file != null) {
      char buffer[PLATFORM_MAX_PATH];
      
      //For each file in the text file
      while (file.ReadLine(buffer, sizeof(buffer))) {
        //Remove final new line
        //buffer length > 0 check needed in case file is completely empty and there is no new line '\n' char after empty string ""
        if (strlen(buffer) > 0 && buffer[strlen(buffer) - 1] == '\n')
          buffer[strlen(buffer) - 1] = '\0';
        
        //Remove any whitespace at either end
        TrimString(buffer);
        
        //Ignore empty lines
        if (strlen(buffer) == 0)
          continue;
          
        //Ignore comment lines
        if (StrContains(buffer, "//") == 0)
          continue; 
        
        //Proceed if directory or file exists
        if (DirExists(buffer))
          processDirectory(buffer, mode);
        else if (FileExists(buffer))
          downloadAndPrecache(buffer, mode);
        else
          LogError("File/Directory '%s' does not exist. Please check entry in config file: '%s'", buffer, modeNiceNames[mode]);
      }
      
      file.Close();
    }
  } else {
    LogError("Missing required config file: '%s'", configFilePath);
  }
}

/**
* Process a directory recursively to precache all subfiles
*/
void processDirectory(char[] directory, int mode)
{
  if (DirExists(directory)) {
    //Ignore inode maps
    if (StrContains(directory, "/.") == strlen(directory)-2 || StrContains(directory, "/..") == strlen(directory)-3)
      return;
  
    DirectoryListing listing = OpenDirectory(directory);
    char subFile[PLATFORM_MAX_PATH];
    FileType subFileType;

    while (listing.GetNext(subFile, sizeof(subFile), subFileType)) {
      //Construct absolute path
      char subFilePath[PLATFORM_MAX_PATH];
      Format(subFilePath, sizeof(subFilePath), "%s/%s", directory, subFile);
    
      if (subFileType == FileType_File)
        downloadAndPrecache(subFilePath, mode);
      else if (subFileType == FileType_Directory)
        processDirectory(subFilePath, mode);
    }
  }
}

/**
* Given a file path and mode, downloads and precaches files
*/
void downloadAndPrecache(char[] file, int mode)
{
  if (FileExists(file)) {
    AddFileToDownloadsTable(file);
    
    if (mode == MODE_DECALS)
      PrecacheDecal(file, true);
    else if (mode == MODE_GENERICS)
      PrecacheGeneric(file, true);
    else if (mode == MODE_MODELS)
      PrecacheModel(file, true);
    else if (mode == MODE_SENTENCEFILES)
      PrecacheSentenceFile(file, true);
    else if (mode == MODE_SOUNDS)
      PrecacheSound(file, true);
  }
}