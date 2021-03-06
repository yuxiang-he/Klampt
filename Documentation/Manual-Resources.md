# Resource management

When building a large, complex robot system, you will typically encounter dozens or hundreds of robot configurations, transforms, inverse kinematics constraints, and paths.  Klamp't has many functions to help make managing these elements easier.

_Visual editing_ is a sort of what-you-see-is-what-you-get (WYSIWYG) editing approach for robotics, and Klamp't tries to make visual editing part of the robot hacking workflow in as painless a manner as possible.

This is made more convenient through the Klamp't resource management mechanism. When working on a large project, it is recommended that configurations, paths, holds, etc. be stored in dedicated sub-project folders to avoid polluting the main Klamp't folder. Resources are compatible with the RobotPose app, as well as the C++ and Python APIs.


_C++ API_. The Klampt/Modeling/Resources.h file lists all available resource types. Note that a sub-project folder can be loaded all at once through the ResourceLibrary class (KrisLibrary/utils/ResourceLibrary.h). After initializing a ResourceLibrary instance with the MakeRobotResourceLibrary function in (Klampt/Modeling/Resources.h) to make it Klamp't-aware, the LoadAll/SaveAll() methods can load an entire folder of resources. These resources can be accessed by name or type using the Get\*() methods.

Alternatively, resource libraries can be saved to XML files via the LoadXml/SaveXml() methods. This mechanism may be useful in the future, for example to send complex robot data across a network.

_Python API_. The klampt.io.resource module allows you to easily load, save, or edit resources. Visual editing is supported for Config, Configs, Vector, and RigidTransform types. See the Python/demos/resourcetest.py demo for more examples about how to use this module.

Currently supported types include:

- Config (.config)
- Hold (.hold)
- Stance (.stance)
- Grasp (.xml)
- Configuration lists (.configs)
- TriMesh (.off, .tri, etc.)
- PointCloud (.pcd)
- Robot (.rob)
- RigidObject (.obj)
- World (.xml)
- Linear paths (.path)
- MultiPath (.xml)

Klamp't also supports the following additional types which do not have a dedicated file extension:

- Vector3
- Matrix3
- RigidTransform
- Matrix
- IKGoal




## RobotPose

## Python editors and resource browsing


