
import 'package:flutter/material.dart';

class FitnessPlusScreen extends StatefulWidget {
  const FitnessPlusScreen({super.key});

  @override
  State<FitnessPlusScreen> createState() => _FitnessPlusScreenState();
}

class _FitnessPlusScreenState extends State<FitnessPlusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header com tabs
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildTab('For You', false),
                          const SizedBox(width: 8),
                          _buildTab('Explore', true),
                          const SizedBox(width: 8),
                          _buildTab('Library', false),
                        ],
                      ),
                      const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Conteúdo scrollável
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seção principal - Strength with Jenn
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDkYGmRGXDdprvjLRZOqelGzhSOWKHj0vmjosVdW6Ns-cVGB2JxgBxhAc53q7vxdHGrzOsH3YHbbfoTrKddDS_XbeBLsU43Wi6h13EgcIUEZQOlQjBPKYcTS_Ci8CnpuzDYXlpnu9kbdeHQivvwlPMiOdT8KEDZXwPOHyUz0HIr_-qEmwe7ry2oiGNv1dXjYlcf-onTvTCdGuzPQla25APvlxlUyJd6BAX8imvuL2zBW4j38fSnYaBjHFGB35psHASzhRvZx8wIAd7w'
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Strength with Jenn',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            '30min • Hip-Hop/R&B',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Seção Meditations
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Meditations',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'New and picked for you',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildMeditationCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCg-f357fwdhfxGS92rIfttqQwOPvUeKnyPYCnTrYXoFrIL6viNT8mAPRA2cTajVLEbtKFn-XrKDIkbCpZuyONfy-rQHxxp566OVpW36gm2-_pDbBDlMT9bZYgsmhvi7l7NDaN0Jm8KU17XrV9LbHqVDmOjh_FuVb-R06sa-lAda4PM0ynT2NKZt1NpSCDE_cf7a_2HqEBH08tIEtXPdYcQbbnNEztelk1Kin8QKfWz96kLzUBBy52WfUNQs79uYjHttbctifACXBBc',
                                  'Meditation with Jonelle',
                                  '5min • Kindness',
                                  true,
                                ),
                                const SizedBox(width: 16),
                                _buildMeditationCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuC7qEcWFNKo1tdGfvvVHwCFEs7RN-Qu-ffofAL3NXOdmkbgkC684hmdCnQvvAq9fAktzPCqX6rBsyb1rrjk4DSdXWuPYaOljV06lNIkBWbkP1FMYEdZYelu9MV0RmcHmFCGsZ7S7eIbeZTCYj_rgVEMfpBFIDpu1NnRNx0yAOaZ_GkSulIzQqkn0-MoQjXNtqRZ_WF9NZW1Kr-wwjwntwaCerqwkKuFPjkc4Fhzaj_G0W9xSGPS00o58jGMeB30f2kXIIfn2RvxYlq4',
                                  'Meditation with Jessica',
                                  '10min • Awareness',
                                  false,
                                ),
                                const SizedBox(width: 16),
                                _buildMeditationCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB4dMMcT4L6Ut9_TMe15sloUwXGmKtbUGOf4fpd8s16W3yTVdadRgx32L5r3ddE2l60a28ezDp4huO8CnbFx9wKmd72zqmwNIVYLsV0gopQhvGGme-BR_knvGkFd_1UDDTcCTRpTcVB0FfTHsqqAGoq4Dh0SqE-10YhOaX-0p487-je-r4tNGYUAH4MrOO7xnUFgc-rHlLGlZOMHK2_wv-6v7Cmf2bcf6odNodXklMctdOfNTqyPCLsN6G7AWpmByD0F0yGLwI2Udj9',
                                  'Meditation with Michael',
                                  '10min • Calm',
                                  false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Seção Activity Types
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Activity Types',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildActivityCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAORzCcKm3qn0eGNDjOLlRehtJpi5ulx-b1MTlQqJKafLDI4GLrLSPzJOy3JxGlJUDcp0KAEf56mW-sl3BP4a-psRCkx-bxknh66A9_py1vK6tE6P7Vggan1iN81VBqIi445EcJN7SEAwyWt5oqPrL4i-lUq_2iCUS1RseMfZ6NhlElJIEnWDWwv6G9YJT_EgoA1oLaBNWppOIv_-eF2w9mAKiLJFdVREXYz4ljJPpXKRXR-DVyUVNmSBMbuXv-5swTa-_z8UEqScvf',
                                  'Meditation',
                                ),
                                const SizedBox(width: 16),
                                _buildActivityCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDWq-IXFcqiglfHOdA6uffOG5me4Z1Uc9GonbZo8MT6uoALflk9QJHEoPN7QIK_o29Q9t978CrbY6mstCXe60NKnCBRpdY2DNSN-RRDbNPnSXGT6e1z988TW-ux2O6b8H7AHpUrqQAvlqifINDh4-WhdDyCowU0883utqLKZ016f7Cjg3mE1VAj_OBI489szRIsdqpAN47m3rVX_lw2Z3oUdXjCUv2vCMB5wuN9grerCNQhBgooR0eH3cbbnzAlcZGPeKysvYwqwbT9',
                                  'Strength',
                                ),
                                const SizedBox(width: 16),
                                _buildActivityCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA1OoGqgQSpwGYFFL7PQBbAIAtq8LSubyxk_zcuVk8ww6FJJ9QjH1mI4f0OP4StPcv15zN8GIbLX5vfdxiNvBsZWrMxUYwi7Fvh7DswDEvT3W23LeUBZodRcV3VmTfAlwudtc1ruoiZ8Ruyj9KUXzSMJwcf_AlMKetibxWVy9f7MfkytxKVWQTI2hyludDvEiITn1nGfhYmP2I595WHpVBtSx1q-OFtIT6g2pYK0a5wpZO7mWsS7VwgfCCsA6emhzj3UEXTw66NofeF',
                                  'HIIT',
                                ),
                                const SizedBox(width: 16),
                                _buildActivityCard(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBd4tZDKlqq5Zz1A7e_RfxjpIoZp3zlwrQJoc5CFL6YJVfT8FddyDYaur9OTz7zzDjYwEltOl3-ywH31KmFDNhv6p640NEy2F26cSFUhNdsdDX_tpgrRS1DJ7XlWzxcx5_1Eq9AgBpneSDiljQ2qWd90iNpRiQ83LDPoouLVmwPqEubGoCbIcIHoJS8mLY3h-xc6BOuS1x-fuMU2JkpRGbN2XOvU0H6bSm4WAZ_m1NajHbuzkFcy9XOKZsOMn5iSLYRJrF6qZWqPmQD',
                                  'Yoga',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Seção Programs
                    Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Programs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Show All',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Created to help you improve your fitness, prepare for new adventures, and focus on mindfulness',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBmHiFAIDzcqBywESnH2x4GXTwiQPOgrX1laxvVbnhlW1pVztuejNEawoiNVayiLj5s81jj_tWTwi4M-V1NWrpyU1-2-7rtCDFBfGIlhKPJyrFhlPJKkPAmhFbsQufV8q2oqBaN4bmHJPIJsNb5ue6P3xM99MdW8J6xiBOAYr0WHNo83ar1cdCuMOt4uWcTigkPJjmBqlzwRue0qnNY4Ups_G7wz-VRNFg19NfIQRR5EZNeivccQS5CO2j9ooQfngwzUVsOwWozei7G'
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: const Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    '3 Perfect Weeks',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          border: const Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.donut_small,
                  color: Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  'Summary',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fitness+',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group,
                  color: Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  'Sharing',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.grey[800] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildMeditationCard(String imageUrl, String title, String subtitle, bool isNew) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: isNew ? Stack(
              children: [
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ) : null,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String imageUrl, String title) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(16),  
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class StatelessWidget {
}