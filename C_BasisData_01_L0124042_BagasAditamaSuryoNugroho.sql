CREATE DATABASE Akademik;

USE Akademik

CREATE TABLE mahasiswa (
    nim VARCHAR(10) PRIMARY KEY,
    nama_mahasiswa VARCHAR(100),
    jurusan VARCHAR(50),
    tanggal_lahir DATE
);

CREATE TABLE dosen (
    nidn VARCHAR(10) PRIMARY KEY,
    nama_dosen VARCHAR(100),
    bidang_keahlian VARCHAR(50),
    tanggal_lahir DATE
);

CREATE TABLE matakuliah (
    kode_mk VARCHAR(8) PRIMARY KEY,
    nama_mk VARCHAR(50),
    sks TINYINT,
);

CREATE TABLE krs (
    id_krs INT PRIMARY KEY,
    nim_mahasiswa VARCHAR(10),
    kode_matakuliah VARCHAR(8),
    nidn_dosen VARCHAR(10),
    semester VARCHAR(10),
    FOREIGN KEY (nim_mahasiswa) REFERENCES mahasiswa(nim),
    FOREIGN KEY (kode_matakuliah) REFERENCES matakuliah(kode_mk),
    FOREIGN KEY (nidn_dosen) REFERENCES dosen(nidn)
);