global class SettingsPostSandboxCopyHandler implements SandboxPostCopy {
	global void runApexClass(SandboxContext context) {
  		Sf.settings.clearEnvSpecificValues();
  	}
}