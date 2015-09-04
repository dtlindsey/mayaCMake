#ifndef SAMPLECMD_H
#define SAMPLECMD_H

#include <maya/MPxCommand.h>

class SampleCmd : public MPxCommand {
 public:
  static MString kCommandString;

  SampleCmd() {}
  virtual ~SampleCmd() {}
  virtual MStatus doIt(const MArgList& args);
  virtual bool isUndoable() const;
  static void* creator();
  static const MString kName;
};

#endif
  
