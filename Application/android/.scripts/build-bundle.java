// ######################## BEGIN ########################
// #### AUTO GENERATION VERSION_CODE AND VERSION_NAME ####
// ######################## BEGIN ########################
def _versionCode = 0
def _versionType = ""
def _major = 0
def _minor = 0
def _patch = 0

def versionPropsFile = file('version.properties.txt')
if (versionPropsFile.canRead()) {
  def Properties versionProps = new Properties()

  versionProps.load(new FileInputStream(versionPropsFile))

  _patch = versionProps['PATCH'].toInteger() + 1
  _major = versionProps['MAJOR'].toInteger()
  _minor = versionProps['MINOR'].toInteger()
  _versionCode = versionProps['VERSION_CODE'].toInteger() + 1
  _versionType = versionProps['VERSION_TYPE'].toString()

  if (_patch == 100) {
    _patch = 0
    _minor = _minor + 1
  }
  if (_minor == 10) {
    _minor = 0
    _major = _major + 1
  }

  versionProps['MAJOR'] = _major.toString()
  versionProps['MINOR'] = _minor.toString()
  versionProps['PATCH'] = _patch.toString()
  versionProps['VERSION_CODE'] = _versionCode.toString()
  versionProps.store(versionPropsFile.newWriter(), null)
} else {
  throw new GradleException("Could not read version.properties!")
}

def _versionName = "${_major}.${_minor}.${_patch}(${_versionCode})"
setProperty("archivesBaseName", "E-Golf App v." + _versionName)
// ######################### END #########################
// #### AUTO GENERATION VERSION_CODE AND VERSION_NAME ####
// ######################### END #########################

// ############## BEGIN #############
// #### CHANGE PATH TO SAVE .AAB ####
// ############## BEGIN #############
// applicationVariants.all { variant ->
//   variant.outputs.all {
//     def taskSuffix = variant.name.capitalize()
//     def copyAABTask = tasks.create(name: "archiveAab${taskSuffix}", type: Copy) {
//         from("${projectDir}") {
//           include "/build/outputs/bundle/release/E-Golf App v." + _versionName + "-release.aab"
//         }
//         into {
//           if (_versionType == "internal") {
//             //variant.buildType.name == "internal"
//             "../../Releases/internal_versions/"
//           } else if (_versionType == "alpha") {
//             //variant.buildType.name == "alpha"
//             "../../Releases/alpha_versions/"
//           } else if (_versionType == "beta") {
//             //variant.buildType.name == "beta"
//             "../../Releases/beta_versions/"
//           } else if (_versionType == "production") {
//             //variant.buildType.name == "production"
//             "../../Releases/production_versions/"
//           }
//         }
//         eachFile { file -> file.path = file.name }
//         includeEmptyDirs = false
//     }

//     copyAABTask.doFirst {
//       if (_versionType == "internal") {
//         ant.move(file: "../../Releases/internal_versions", tofile: "../../Releases/internal_versions/old_version", flatten: "true", includeEmptyDirs: "false")
//       } else if (_versionType == "alpha") {
//         ant.move(file: "../../Releases/alpha_versions", tofile: "../../Releases/alpha_versions/old_version", flatten: "true", includeEmptyDirs: "false")
//       } else if (_versionType == "beta") {
//         ant.move(file: "../../Releases/beta_versions", tofile: "../../Releases/beta_versions/old_version", flatten: "true", includeEmptyDirs: "false")
//       } else if (_versionType == "production") {
//         ant.move(file: "../../Releases/production_versions", tofile: "../../Releases/production_versions/old_version", flatten: "true", includeEmptyDirs: "false")
//       }
//     }

//     def bundleTaskName = "bundle${taskSuffix}"
//     println "Bundle task name: " + bundleTaskName
//     if (tasks.findByName(bundleTaskName)) {
//       tasks[bundleTaskName].finalizedBy = [copyAABTask]
//     }
//   }
// }
// ############### END ##############
// #### CHANGE PATH TO SAVE .AAB ####
// ############### END ##############