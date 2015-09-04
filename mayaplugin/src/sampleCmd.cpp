#include "sampleCmd.h"
#include <maya/MGlobal.h>

const MString SampleCmd::kName("sampleCmd");

void* SampleCmd::creator() {
  return new SampleCmd;
}


bool SampleCmd::isUndoable() const {
  return false;
}


MStatus SampleCmd::doIt(const MArgList& args) {
  MStatus status;
  MGlobal::displayInfo("Good job!");
  return MS::kSuccess;
}

