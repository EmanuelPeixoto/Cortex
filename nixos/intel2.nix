{
  # Habilita o driver Intel
  drivers.intel.enable = true;

  # Seção de configuração do driver i915
  # https://wiki.archlinux.org/title/Intel_graphics#Kernel_mode_setting
  kernel.modules.i915 = {
    options.i915_enable_psr = true;
    options.i915_enable_guc_submission = true;
    options.i915_enable_guc_suspend = true;
    options.i915_enable_guc_wg = true;
    options.i915_enable_guc_mappable = true;
    options.i915_enable_guc_scheduler = true;
    options.i915_enable_guc_debug = true;
    options.i915_enable_guc_log = true;
    options.i915_enable_guc_trace = true;
    options.i915_enable_guc_power_metrics = true;
    options.i915_enable_guc_perf_metrics = true;
    options.i915_enable_guc_pmu = true;
    options.i915_enable_guc_display_metrics = true;
    options.i915_enable_guc_display_trace = true;
    options.i915_enable_guc_display_debug = true;
    options.i915_enable_guc_display_log = true;
    options.i915_enable_guc_display_perf_metrics = true;
    options.i915_enable_guc_display_power_metrics = true;
    options.i915_enable_guc_display_pmu = true;
    options.i915_enable_guc_display_power = true;
    options.i915_enable_guc_display_state = true;
    options.i915_enable_guc_display_state_trace = true;
    options.i915_enable_guc_display_state_debug = true;
    options.i915_enable_guc_display_state_log = true;
    options.i915_enable_guc_display_state_perf_metrics = true;
    options.i915_enable_guc_display_state_power_metrics = true;
    options.i915_enable_guc_display_state_pmu = true;
  };
}
