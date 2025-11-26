import '../../domain/models/file_model.dart';

class FileMock {
  static List<FileModel> getFiles() {
    return [
      FileModel(
        fileName: 'Tech requirements.pdf',
        fileSize: '200 KB',
        dateUploaded: 'Jan 4, 2025',
        lastUpdated: 'Jan 4, 2025',
        uploadedBy: UserInfo(
          name: 'Olivia Rhye',
          email: 'olivia@untitled.com',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD-lqKNRHe32GbDk5JlEkBW1653UWui4a3gMU3nNDDjRhX6MfVf7KnZ9QgT1-I1KPLqSi6jqpL8v-I0MANfBz3SG51R3yZDWeDyanrYcbeU0pFvyD0jZjDfk5lgb1WPZxVS0BDZCnd0pWd-aK8Oqgyt5TBelgbmdWXrEo7ofnU8rI7-sK7_tdjinQuDMDVsjitnfZojuMELsJ3TTeX0_tvKtithAPdBuKEAIxQ6q6VgGW5muV9cKYmjUgeRcl8HjBUUl5i7vtGoNkA',
        ),
        fileType: 'pdf',
        iconUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBwG6aBrgkbaOBRLkr29Xg_hlBumtwWa_PnmQbjDdfrX0dNAuW638sXkyaHK3Lzwc_Y9HrXZF6eVxQLBCfP2UI5s19zJiR7tIysU40Q51R8b5QK7woCx3Me2js42OpwR78M_WXrR0CTfKoOLc27JQkr4z2yoXetm4Z_RrGEhw0rD5K7xrxNaX9ffGQxky15bhw7cMArrvee1XTZldpLe-CNBL9kwoEboAiwFXqES6cj7EdrZ5f415QuqUldKHY2bdzjmBOZuUB7Z9s',
      ),
      FileModel(
        fileName: 'Dashboard screenshot.jpg',
        fileSize: '720 KB',
        dateUploaded: 'Jan 4, 2025',
        lastUpdated: 'Jan 4, 2025',
        uploadedBy: UserInfo(
          name: 'Phoenix Baker',
          email: 'phoenix@untitled.com',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDUfvOQBvWFfcCwfFIyL0FjUMYdHp4b_RfyZqRNXMMiF1QL6kQjSHk165en6xnk80-WxzWwMeL4MQVSdDqe3tZSBhOgALOxrC6B0v3e7vPTMSMgfPMBIY_4AKQq8S66zslcqBFWTWQQDHrjmD4Qh6KUoGNzEV2H6-jC9_6dcjpY4syK_pswQEbsYqfEPJawWNmyK8TuiDVSM7hIjVmfULvSDGLTCPMwWDEgNEA4zoxCVDJcSRXq7GE_qYQBFfC1XVAMwSBCv0f2zPE',
        ),
        fileType: 'jpg',
        iconUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBgLqOheOHcqfOxNwlO2P2efV1OewpFOaI7SPmLLZW4frg2NnKQC5Gmf6dEwCk_zRDHtCJWtv2Gdy29hgmBv3-8v_uMdf4AK56hV-IxbUx4vbIs5TSD3S1wMa7oo0_8nDZ84shu6txJStKNqDoYgS68B7SVyBAV-V5a_71RZttVLWKwN2w_5iPNUVA4oJBCtMKtLNC_glewZikupV6qyopJQtX_QK38qoClJwBI2TUSAIZCwJfHm6mpSn3xmaVmqM_5aTFhAiUu6bk',
      ),
      FileModel(
        fileName: 'Dashboard prototype recording.mp4',
        fileSize: '16 MB',
        dateUploaded: 'Jan 2, 2025',
        lastUpdated: 'Jan 2, 2025',
        uploadedBy: UserInfo(name: 'Lana Steiner', email: 'lana@untitled.com'),
        fileType: 'mp4',
        iconUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCN8dtR7Ym5IfBd4ViP5QoIuwEbphJj3TstqLGHAOeJdpJ69GqGg-3wu899EkND0dJ8KPSauzTz0a-ijrDCWVHIzQhJ2fR1gMl7lmGrMdNEvkSIRI8JE-Y1HFG3Mnfg4rSzal-q5tSsZ3IQRgXTdxidsjaEMbkGEChrVgOxSBevgZ_bK9b49c8M0PU9zXN5kBJ7K4qbLjUxU60ijeN-VVvZ-0vhlm3dJp4DGlbrryY6fWjxWX0YQO4o0-DxnF84_nFYzprsyggBBZE',
      ),
      FileModel(
        fileName: 'Dashboard prototype FINAL.fig',
        fileSize: '4.2 MB',
        dateUploaded: 'Jan 6, 2025',
        lastUpdated: 'Jan 6, 2025',
        uploadedBy: UserInfo(
          name: 'Demi Wilkinson',
          email: 'demi@untitled.com',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCk1EolW0P2BG552mdcsHWqfO-0jAgUlLjcPwpM0Sgwo_qMQR4Q5qVRhcsaxKzb_HgDHQ-CjG4TCGNtGNLCvGaivpXUI6gWiKA_g9bRZEO_OfG5i8ZgBteKRd0jOWMlimRGvyVEbD2vAw2z_QoTZFsb-WYM4t6tWXjQ6-1U0zrRtrwai1UrduLiNoToDcYpfSZ4CkW1JaKaL5cIDoDooFZd6jc_IvMyzToBIg9_9PdGjELF7I363BvoIxeIrwgBdaS_y1tTDVsgfuE',
        ),
        fileType: 'fig',
        iconUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCYM9_t2PzWqqdaHuXR76MQdP_M1SGQD_DcxDfao_6DvkxmMb5_L5j9atNBnVy5lEzdyXXHYRbY56XLz8O8Kcip1Jc6zv9hM-feESGD3p1UZWZksK2gASC1yRYWGs2CnwdPjzMwGMZQw8JJ32RCqESPSK-6xl8JMXBx-bxScIynXx1XsQ3Yn9njO8Auis4pUJEE03GCOFSYjOfJqLl5uGbMeCGvLtI2Ozr9afO5djw-ibyOdSOAtGzJYOduyzY_EIctFz1YZvN7LnY',
      ),
      FileModel(
        fileName: 'UX Design Guidelines.docx',
        fileSize: '400 KB',
        dateUploaded: 'Jan 8, 2025',
        lastUpdated: 'Jan 8, 2025',
        uploadedBy: UserInfo(
          name: 'Candice Wu',
          email: 'candice@untitled.com',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuByO-cVGFfFlNHFw2a2j92fdYYsO_egAVpgyYGS3af1cA6BBLGCRZSa_ljeanLLHUZSM8udHV6BO_zjIaLK2fySeJCA6avnaihKUtUHs3jYctc_itlrAipTEYcQJD64XQnPTL2M--pfTLk4r6Cgi73UzqDI7tby1OkHu8_dSH6OIHi6P7EwBfUhCa4gBgA3A17Kx_N3XA19AwSCbuUvcl7l5oUyFYS8qSaLiak2B2VfoB9cXqMfdjkKeOsWi-qroZpkePG_Clj9HuI',
        ),
        fileType: 'docx',
        iconUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAFmpFcDEis9U2uGr3K4-jhPKgClk4mQq9Iy5VBNkTpvv7b2fdzrNwyz8F0B1GOII7pwmOVIXL3ylnPMww1C5HXTBmXEkCPHIqn4u5hhGf85NJN1tn56GR0fqYhfMkKN_CUQmYhmX7kCURsf6KPetbbLj8lt0525vXFPIWucqs1lRob3lDF1wEkfOle9HC0ww3gEcSWnLtoaSaEtMTDQMvQ4SBjHc_IEQe3Ysmqr_9bjnhbA8Daifki6Azv3lv5NL7-OCz1GeixYag',
      ),
      FileModel(
        fileName: 'Dashboard interaction.aep',
        fileSize: '12 MB',
        dateUploaded: 'Jan 6, 2025',
        lastUpdated: 'Jan 6, 2025',
        uploadedBy: UserInfo(
          name: 'Natali Craig',
          email: 'natali@untitled.com',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDsTnhDoEZmKtgdrBlVp5ePDq1ODRR9Kg9Builr-ScqkgVPvUXfDw3OX0g1S2VhltGUoTzSoGOpb8bvwneCEczMf3WvKj4F2vHbVa_DtWsZDfzg_siF7suRKEEz30ZK5Y1trTnx0MEblJEHEZiFZtUNw6otcxac8FN7MVa5yEdkTc-YUa7bn5qii9vuwn8CMXfIL9trKm8wZW15Nd5u4rjmuH08IM7LOB1X3RD_yJCuEAg0AIdmr_6zeAuEYuaLVsP65zAkvgV31gM',
        ),
        fileType: 'aep',
        iconUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBipQzPOFN-HlmzyTrFbKsGauk7ZIMEJ2r3NwRdOhCv62NZUxj3FW894Upe07JeI_hXs2DJA2YBKpOnwjBT6vg1TdNO7VpWnp8TFGZz9PmNC_-cR4tSqufAoY5e4Mz9BVqM2H2VyxVq-vwOtV7kttrm9wfEpas26UVN0mPMZF5G-1OBHVxRY8YQgBpb-pWhld2F--YrBvR9mtk9I5pT7_VSb18P0xfCqrX2CSLVj1XmFDYNduz9YTsA12PxwXOHraTOAP6U6sFzr2Q',
      ),
      FileModel(
        fileName: 'Briefing call recording.mp3',
        fileSize: '800 KB',
        dateUploaded: 'Jan 4, 2025',
        lastUpdated: 'Jan 4, 2025',
        uploadedBy: UserInfo(
          name: 'Drew Cano',
          email: 'drew@untitled.com',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDFYTX5M2FlYJdqC0a6QLCVRS-Dwq-mhVGagE5tD__6_C2c3eaYk-a_7RStWbGoexxj5B4njY8IJKxUSRuyGiH23_51l8MUeutPPpTsQq_l2DGAz8UNK7B3zgvwTzUxUlUiKMxBB1yKW7ttCn4VOuR5sNglMEm_YY2-DaWfmja7olMkqXzR3SWuq7k8H2GIuDpYz2JPuSrIcr1buIA5RDHqDMwqqDMTfUaeyjxWYHsq_cjmPEyK1b77kFKj0VylZBGPibqoBTz_ocg',
        ),
        fileType: 'mp3',
        iconUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDHjIb0mZ3Kn_qTQh9GztJ9DjuaybmcjkO3Bteib0ogCLQLLee-OGy5PdYxsdqv2b2syN2taI3U8gIeWpdPsN22SXcI2iFDjBotgLi1VqJ817hV9RrgCzmVCF8el2mJJlms0kNsI_Gls5DYKUGzH8w4MZquAf25O2dbxVdKbUshLgy5V81UfToFO29br02HYm_EQ50tQrA9XjTR_a44hAeO6xq0k0x6bJDCWQDqE4DEeCQEoxb7AGPLLBRpaqK92BojKGH-GwQXxXc',
      ),
    ];
  }
}
