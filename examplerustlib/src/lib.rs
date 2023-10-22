use std::io;
use std::io::Write;

/// Writes an example message into w.
pub fn write_rust_message<W: io::Write>(w: &mut W) -> io::Result<()> {
    write!(
        w,
        "Hello from Rust! OS={} ARCH={}",
        std::env::consts::OS,
        std::env::consts::ARCH
    )
}

/// Copies a message from Rust into `dest_buf`, which can hold up to `dest_len` bytes. The buffer
/// will be terminated with a NUL byte. This function returns the number of bytes of message,
/// or -1 on error.
///
/// # Safety
/// Same as `std::slice::from_raw_parts_mut`
#[no_mangle]
pub unsafe extern "C" fn copy_rust_message(dest_buf: *mut u8, dest_len: usize) -> i32 {
    let mut dest_slice = unsafe { std::slice::from_raw_parts_mut(dest_buf, dest_len) };
    // let mut writer = FixedSizeWriter::new(dest_slice);
    if write_rust_message(&mut dest_slice).is_err() {
        // the buffer was not big enough
        return -1;
    }
    let msg_len = dest_len - dest_slice.len();
    // terminate with a NUL byte
    if dest_slice.write(b"\x00").is_err() {
        // the buffer was not big enough
        return -1;
    }

    // theoretically possible to have more than i32; lets's practice being paranoid
    i32::try_from(msg_len).unwrap_or(-1)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_rust_message() {
        let mut buf = Vec::new();
        write_rust_message(&mut buf).unwrap();
        let s = std::str::from_utf8(buf.as_slice()).unwrap();
        assert!(
            s.starts_with("Hello from Rust! OS="),
            "Did not start with correct message; s={s:#?}"
        );
    }

    #[test]
    fn test_write_fixed_buffer() {
        // write the whole message to the buffer
        let mut mut_bytes = [0u8; 128];
        let mut_bytes_len = mut_bytes.len();
        let mut writer_slice = &mut mut_bytes[..];
        write_rust_message(&mut writer_slice).unwrap();
        let msg_len = mut_bytes_len - writer_slice.len();

        let s = std::str::from_utf8(&mut_bytes[0..msg_len]).unwrap();
        assert!(
            s.starts_with("Hello from Rust! OS="),
            "Did not start with correct message; s={s:#?}"
        );

        // write a message that is too short

        let mut short_buffer = &mut mut_bytes[0..5];
        let short_buffer_len = short_buffer.len();
        assert_eq!(
            write_rust_message(&mut short_buffer).unwrap_err().kind(),
            io::ErrorKind::WriteZero
        );
        let msg_len = short_buffer_len - short_buffer.len();
        let s = std::str::from_utf8(&mut_bytes[0..msg_len]).unwrap();
        assert_eq!("Hello", s);
    }

    #[test]
    fn test_copy_from_rust() {
        let mut mut_bytes = [0u8; 128];
        let result = unsafe { copy_rust_message(mut_bytes.as_mut_ptr(), mut_bytes.len()) };
        assert!(result > 0);
        assert_eq!(mut_bytes[result as usize], 0);
        let s = std::str::from_utf8(&mut_bytes[0..result as usize]).unwrap();
        assert!(
            s.starts_with("Hello from Rust! OS="),
            "Did not start with correct message; s={s:#?}"
        );
    }
}
