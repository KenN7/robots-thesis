#!/usr/bin/python3
import cppyy
from cppyy import addressof, bind_object
import pathlib
import tempfile
import sys
import xml.etree.ElementTree as ET
import config


def load_argos():
    cppyy.include(
        str(
            pathlib.Path(config.ARGOS_PREFIX)
            / "include/argos3/core/simulator/simulator.h"
        )
    )
    cppyy.include(
        str(
            pathlib.Path(config.ARGOS_PREFIX)
            / "include/argos3/core/simulator/space/space.h"
        )
    )
    cppyy.include(
        str(
            pathlib.Path(config.ARGOS_PREFIX)
            / "include/argos3/core/simulator/loop_functions.h"
        )
    )
    cppyy.include(
        str(
            pathlib.Path(config.ARGOS_PREFIX)
            / "include/argos3/core/utility/plugins/dynamic_loading.h"
        )
    )
    cppyy.load_library(
        str(pathlib.Path(config.ARGOS_PREFIX) / "lib/argos3/libargos3core_simulator.so")
    )

    cppyy.include(
        str(
            pathlib.Path(config.ARGOS_PREFIX)
            / "include/argos3/plugins/robots/e-puck/simulator/epuck_entity.h"
        )
    )

    cppyy.include(
        str(
            pathlib.Path(config.ARGOS_PREFIX)
            / "include/argos3/demiurge/loop-functions/CoreLoopFunctions.h"
        )
    )
    from cppyy.gbl import argos

    mak = argos.CSimulator.GetInstance()
    arr = argos.CDynamicLoading.LoadAllLibraries()

    return mak, arr


def main():
    mak, arr = load_argos()

    tree = ET.parse(sys.argv[1])
    root = tree.getroot()
    controllers = root.find("controllers")
    if controllers:
        for controller in controllers:
            id = controller.get('id')
            controller.set("library", config.CONTROLLERS[id])
            # path = pathlib.Path(controller.get("library"))
            # print(path)
    loops = root.find("loop_functions")
    if loops:
        findloop = pathlib.Path(config.LOOP_PREFIX).glob("**/*.so")
        old_loop_path = pathlib.Path(loops.get("library"))
        looplist = [ loop for loop in findloop if loop.name == old_loop_path.name ]
        if len(looplist) == 0:
            print('Could not find the loopfunc in the prefix')
            raise
        looppath = looplist[0]
        if len(looplist) > 1:
            print('multiple possible loopfunc file found: {}'.format(looplist))
        print('Using loopfunc: {}'.format(looppath))
        loops.set('library', str(looppath.absolute()))
        # print(looppath)

    tmpfile = tempfile.NamedTemporaryFile()
    tree.write(tmpfile.name)

    mak.SetExperimentFileName(tmpfile.name)
    mak.SetRandomSeed(10)
    mak.LoadExperiment()

    cSpace = mak.GetSpace()
    cEntities = cSpace.GetEntitiesByType("controller")
    sizeE = cEntities.size()

    mak.Execute()

    loopfunc = mak.GetLoopFunctions()

    from cppyy.gbl import CoreLoopFunctions

    loopfunc = bind_object(addressof(loopfunc), CoreLoopFunctions)
    score = loopfunc.GetObjectiveFunction()
    print(score)

    mak.Destroy()
    tmpfile.close()


if __name__ == "__main__":
    main()
