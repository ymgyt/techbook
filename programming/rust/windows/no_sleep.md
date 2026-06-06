# WindowsでSleepさせない

```rust

use windows::Win32::System::Power::{
    ES_CONTINUOUS, ES_DISPLAY_REQUIRED, ES_SYSTEM_REQUIRED, EXECUTION_STATE,
    SetThreadExecutionState,
};

#[derive(Debug)]
pub struct NoSleep {
    previous: EXECUTION_STATE,
}

impl NoSleep {
    /// windows apiを利用してPCのスリープを防止する
    pub fn init() -> anyhow::Result<Self> {
        // https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setthreadexecutionstate
        let esflags = ES_CONTINUOUS | ES_DISPLAY_REQUIRED | ES_SYSTEM_REQUIRED;

        unsafe {
            // If the function succeeds, the return value is the previous thread execution state.
            // If the function fails, the return value is NULL.
            let previous = SetThreadExecutionState(esflags);
            if previous == EXECUTION_STATE(0) {
                return Err(anyhow::anyhow!(
                    "Failed to SetThreadExecutionState windows syscall to prevent sleep"
                ));
            }
            Ok(Self { previous })
        }
    }
}

impl Drop for NoSleep {
    fn drop(&mut self) {
        unsafe {
            SetThreadExecutionState(self.previous);
        }
    }
}
```
