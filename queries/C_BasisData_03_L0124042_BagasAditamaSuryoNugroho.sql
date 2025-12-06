-- =====================================================================
-- SOAL 1: PEMINJAMAN BUKU OLEH ANI WIJAYA
-- =====================================================================
BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @anggotaID INT = 2;
    DECLARE @bukuID INT = 4;
    DECLARE @stokBuku INT;

    -- Cek apakah anggota terdaftar
    IF NOT EXISTS (SELECT 1 FROM anggota WHERE anggota_id = @anggotaID)
    BEGIN
        RAISERROR('Anggota tidak ditemukan. Transaksi dibatalkan.', 16, 1);
    END

    -- Cek stok buku yang tersedia
    SELECT @stokBuku = jumlah_tersedia FROM buku WHERE buku_id = @bukuID;

    IF (@stokBuku > 0)
    BEGIN
        UPDATE buku SET jumlah_tersedia = jumlah_tersedia - 1 WHERE buku_id = @bukuID;
        PRINT 'Stok buku berhasil diperbarui.';

        -- ID Peminjaman, ID Anggota, ID Buku, ID Petugas (misal: 1), Tgl Pinjam, Tgl Kembali, Status
        INSERT INTO peminjaman (peminjaman_id, anggota_id, buku_id, petugas_id, tanggal_peminjaman, tanggal_pengembalian, status)
        VALUES (6, @anggotaID, @bukuID, 1, GETDATE(), DATEADD(day, 14, GETDATE()), 'Dipinjam');
        PRINT 'Data peminjaman baru berhasil ditambahkan.';

        COMMIT TRANSACTION;
        PRINT 'Transaksi peminjaman berhasil diselesaikan.';
    END

    ELSE
    BEGIN
        RAISERROR('Stok buku tidak tersedia. Transaksi dibatalkan.', 16, 1);
    END
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Terjadi kesalahan. Semua perubahan telah dibatalkan.';
    PRINT 'Pesan Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- =====================================================================
-- SOAL 2: MENGHAPUS DATA PEMINJAMAN
-- =====================================================================
BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @peminjamanID INT = 2;
    DECLARE @bukuID_dihapus INT;

    -- Cek apakah data peminjaman ada
    IF NOT EXISTS (SELECT 1 FROM peminjaman WHERE peminjaman_id = @peminjamanID)
    BEGIN
        RAISERROR('Data peminjaman tidak ditemukan. Transaksi dibatalkan.', 16, 1);
    END

    -- Ambil ID buku dari data peminjaman yang akan dihapus
    SELECT @bukuID_dihapus = buku_id FROM peminjaman WHERE peminjaman_id = @peminjamanID;

    DELETE FROM peminjaman WHERE peminjaman_id = @peminjamanID;
    PRINT 'Data peminjaman berhasil dihapus.';

    UPDATE buku SET jumlah_tersedia = jumlah_tersedia + 1 WHERE buku_id = @bukuID_dihapus;
    PRINT 'Stok buku berhasil dikembalikan.';

    COMMIT TRANSACTION;
    PRINT 'Transaksi penghapusan berhasil diselesaikan.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Terjadi kesalahan saat menghapus data. Perubahan dibatalkan.';
    PRINT 'Pesan Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- =====================================================================
-- SOAL 3: PEMINJAMAN DUA BUKU DENGAN SAVEPOINT
-- =====================================================================
BEGIN TRANSACTION; 

DECLARE @anggotaID_siti INT = 4;
DECLARE @bukuID_laskar INT = 1;
DECLARE @bukuID_sejarah INT = 5;

-- Cek apakah anggota terdaftar
IF NOT EXISTS (SELECT 1 FROM anggota WHERE anggota_id = @anggotaID_siti)
BEGIN
    PRINT 'Anggota tidak ditemukan. Transaksi dibatalkan.';
    ROLLBACK TRANSACTION;
END
ELSE
BEGIN
    -- --- Proses Peminjaman Buku Pertama (Laskar Pelangi) ---
    DECLARE @stokBukuPertama INT;
    SELECT @stokBukuPertama = jumlah_tersedia FROM buku WHERE buku_id = @bukuID_laskar;

    IF (@stokBukuPertama > 0)
    BEGIN
        UPDATE buku SET jumlah_tersedia = jumlah_tersedia - 1 WHERE buku_id = @bukuID_laskar;
        INSERT INTO peminjaman (peminjaman_id, anggota_id, buku_id, petugas_id, tanggal_peminjaman, tanggal_pengembalian, status)
        VALUES (7, @anggotaID_siti, @bukuID_laskar, 2, GETDATE(), DATEADD(day, 14, GETDATE()), 'Dipinjam');
        PRINT 'Peminjaman buku pertama (Laskar Pelangi) berhasil.';

        SAVE TRANSACTION PeminjamanPertamaBerhasil;
        PRINT 'SAVEPOINT dibuat setelah peminjaman pertama.';

        -- --- PROSES PEMINJAMAN BUKU KEDUA (Sejarah Peradaban Dunia) ---
        BEGIN TRY
            DECLARE @stokBukuKedua INT;
            SELECT @stokBukuKedua = jumlah_tersedia FROM buku WHERE buku_id = @bukuID_sejarah;

            IF (@stokBukuKedua <= 0)
            BEGIN
                RAISERROR('Stok buku kedua (Sejarah) habis.', 16, 1);
            END
            
            UPDATE buku SET jumlah_tersedia = jumlah_tersedia - 1 WHERE buku_id = @bukuID_sejarah;
            INSERT INTO peminjaman (peminjaman_id, anggota_id, buku_id, petugas_id, tanggal_peminjaman, tanggal_pengembalian, status)
            VALUES (8, @anggotaID_siti, @bukuID_sejarah, 2, GETDATE(), DATEADD(day, 14, GETDATE()), 'Dipinjam');
            PRINT 'Peminjaman buku kedua (Sejarah) berhasil.';
            
        END TRY

        BEGIN CATCH
            -- Jika peminjaman kedua gagal, kembali ke titik SEBELUM peminjaman kedua
            ROLLBACK TRANSACTION PeminjamanPertamaBerhasil;
            PRINT 'Peminjaman buku kedua gagal. Transaksi dikembalikan ke SAVEPOINT.';
            PRINT 'Pesan Error: ' + ERROR_MESSAGE();
        END CATCH;
    END

    ELSE
    BEGIN
        -- Jika buku pertama stoknya habis, batalkan seluruh transaksi
        PRINT 'Stok buku pertama (Laskar Pelangi) tidak tersedia. Seluruh transaksi dibatalkan.';
        ROLLBACK TRANSACTION;
    END

    COMMIT TRANSACTION;
    PRINT 'Transaksi akhir di-COMMIT.';
END
GO